from flask import Flask, render_template, url_for, request, redirect
from werkzeug.utils import secure_filename
import cx_Oracle
import config
import os

cx_Oracle.init_oracle_client(lib_dir="/Users/Alibek/Downloads/instantclient_19_8")
connection = cx_Oracle.connect(config.username, config.password, config.dsn, encoding=config.encoding)

app = Flask(__name__)
app.config['UPLOAD_PATH'] = 'static/images'

@app.route('/', methods=['GET', 'POST'])
def index():
    cursor = connection.cursor()

    cursor2 = connection.cursor()
    cursor2.execute('select * from table(algos.top_five_film)')
    top_films = cursor2.fetchall()

    if request.method == "POST":
        films = []
        for i in request.form:
            if i == 'text':
                print('text')
                cursor.execute(f'select * from table(search_film(\'{request.form["text"]}\'))')
                films = cursor.fetchall()
            else:
                if request.form['data'] == '1988' or request.form['data'] == '1989' or request.form['data'] == '1990' or request.form['data'] == '1991' or request.form['data'] == '1992' or request.form['data'] == '1993':
                    print('Year')
                    cursor.execute(f'select * from table(films_filter.year_search({request.form["data"]}))')
                    films = cursor.fetchall()
                elif request.form['data'] == 'Comedy' or request.form['data'] == 'War' or request.form['data'] == 'Crime' or request.form['data'] == 'Horror' or request.form['data'] == 'Drama' or request.form['data'] == 'Science Fiction':
                    print('Genre')
                    cursor.execute(f'select * from table(films_filter.subject(\'{request.form["data"]}\'))')
                    films = cursor.fetchall()
                elif request.form['data'] == 'Popular':
                    print('Popular')
                    cursor.execute(f'select * from table(films_filter.popularity)')
                    films = cursor.fetchall()
                else:
                    print('Length')
                    cursor.execute(f'select * from table(films_filter.length_desc)')
                    films = cursor.fetchall()

        return render_template('index.html', films=films, top_films=top_films)
    else:

        cursor.execute('select * from table(all_films)')
        films = cursor.fetchall()

        return render_template('index.html', films=films, top_films=top_films)


@app.route('/film/<int:id>')
def film(id):
    cursor = connection.cursor()
    cursor.execute(f"select * from films where id = {id}")
    film = cursor.fetchone()

    cursor2 = connection.cursor()
    cursor2.execute('begin algos.increment_count(:1); end;', [id])
    connection.commit()

    return render_template('film.html', film=film)


@app.route('/admin')
def admin():
    cursor = connection.cursor()
    cursor.execute('select * from films order by id desc')
    films = cursor.fetchall()

    return render_template('admin.html', films=films)


@app.route('/statistics')
def statistics():
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM TABLE(top_year)')
    top_year = cursor.fetchall()
    labels = [row[0] for row in top_year]
    data_sets = [row[1] for row in top_year]

    cursor2 = connection.cursor()
    cursor2.execute('SELECT * FROM TABLE(top_subject)')
    top_subject = cursor2.fetchall()
    labels2 = [row[0] for row in top_subject]
    data_sets2 = [row[1] for row in top_subject]

    return render_template('statistics.html', labels=labels, data_sets=data_sets, labels2=labels2, data_sets2=data_sets2)


@app.route('/logs')
def logs():
    cursor = connection.cursor()
    cursor.execute('select * from table(admin_actions)')
    items = cursor.fetchall()
    return render_template('logs.html', items=items)


@app.route('/insert', methods=['GET', 'POST'])
def insert():
    if request.method == 'POST':
        f = request.files['file']
        f.save(os.path.join(app.config['UPLOAD_PATH'], secure_filename(f.filename)))

        cursor = connection.cursor()
        cursor.execute('begin query.insert_films(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10);  end;', [
            int(request.form['year']),
            int(request.form['length']),
            str(request.form['title']),
            str(request.form['genre']),
            str(request.form['actor']),
            str(request.form['actress']),
            str(request.form['director']),
            int(request.form['popularity']),
            str(request.form['awards']),
            str(f.filename)
        ])

        connection.commit()
        return redirect('/admin')


@app.route('/update', defaults={'id': None}, methods=['GET', 'POST'])
@app.route('/update/<int:id>')
def show_update(id):
    if request.method == 'POST':
        f = request.files['file']
        f.save(os.path.join(app.config['UPLOAD_PATH'], secure_filename(f.filename)))

        cursor = connection.cursor()
        cursor.execute('begin query.update_films(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11);  end;', [
            int(request.form['year']),
            int(request.form['length']),
            str(request.form['title']),
            str(request.form['genre']),
            str(request.form['actor']),
            str(request.form['actress']),
            str(request.form['director']),
            int(request.form['popularity']),
            str(request.form['awards']),
            str(f.filename),
            str(request.form['id'])
        ])
        connection.commit()

        return redirect('/admin')
    else:
        cursor = connection.cursor()
        cursor.execute('select * from films where id = :1', [id])
        film = cursor.fetchone()

        return render_template('update.html', film=film)


@app.route('/delete/<int:id>')
def delete(id):
    cursor = connection.cursor()
    cursor.execute('begin query.delete_film(:1); end;', [id])
    connection.commit()

    return redirect('/admin')


if __name__ == "__main__":
    app.run(debug=True)