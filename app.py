from flask import Flask, render_template,redirect, flash, request, url_for, session, jsonify
from flask_mysqldb import MySQL
import pandas as pd
import logging
import bcrypt
import socket
from datetime import datetime

app = Flask(__name__)


# Setup logging for debugging

# Setup logging for debugging
logging.basicConfig(level=logging.DEBUG)

app.config["MYSQL_HOST"] = '125.564.12.1'
app.config["MYSQL_USER"] = 'root'
app.config["MYSQL_PASSWORD"] = ""
app.config["MYSQL_DB"] = 'jail'
app.config['SECRET_KEY'] = 'aVerySecretKey'



mysql = MySQL(app)
def runstatement(statement, params=None):
    cursor = mysql.connection.cursor()
    try:
        cursor.execute(statement, params)
        results = cursor.fetchall()
        mysql.connection.commit()
    except Exception as e:
        logging.error(f"Database error: {e}")
        mysql.connection.rollback()
        results = []
    finally:
        if cursor.description:
            column_names = [desc[0] for desc in cursor.description]
            df = pd.DataFrame(results, columns=column_names)
        else:
            df = pd.DataFrame()
        cursor.close()
    return df


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password'].encode('utf-8')  # Encode the password to bytes
        role = request.form['role']
        
        # Generate salt and hash the password
        salt = bcrypt.gensalt()
        hashed_password = bcrypt.hashpw(password, salt)

        cursor = mysql.connection.cursor()
        try:
            # Ensure the hashed password is stored as a string for database compatibility
            cursor.execute("INSERT INTO users (username, password, role) VALUES (%s, %s, %s)",
                           (username, hashed_password.decode('utf-8'), role))
            mysql.connection.commit()
            flash('User registered successfully!')
            return redirect(url_for('login'))
        except Exception as e:
            mysql.connection.rollback()
            flash(f'Error registering user: {e}')
        finally:
            cursor.close()

    return render_template('register.html')



@app.route('/login', methods=['GET', 'POST'])
def login():
    if 'username' in session:
        return render_template('index.html')
    
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password'].encode('utf-8')  # Encode the password to bytes
        cursor = mysql.connection.cursor()
        try:
            cursor.execute("SELECT password FROM users WHERE username = %s", [username])
            user = cursor.fetchone()
            if user and bcrypt.checkpw(password, user[0].encode('utf-8')):
                session['username'] = username
                return redirect(url_for('home'))
            else:
                flash('Invalid username or password')
        finally:
            cursor.close()
    return render_template('login.html')


@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('login'))

@app.route('/')
def home():
    # if 'username' not in session:
    #     return redirect(url_for('login'))
    return render_template('index.html')


@app.route('/view_criminals')
def view_criminals():
    if 'username' not in session:
        return redirect(url_for('login'))
    df = runstatement("SELECT * FROM `Criminals`")
    # Convert DataFrame to a list of dictionaries for easier template processing
    criminals_list = df.to_dict(orient='records')
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT role FROM users WHERE username = %s", [session['username']])
    role = cursor.fetchone()
    return render_template('view_criminals.html', criminals=criminals_list, role=role[0])

@app.route('/add_criminals', methods=['POST'])
def add_criminal():
    if 'username' not in session:
        return redirect(url_for('login'))
    last = request.form.get('last')
    first = request.form.get('first')
    street = request.form.get('street')
    city = request.form.get('city')
    state = request.form.get('state')
    zip_code = request.form.get('zip')  # 'zip' is a built-in function, using zip_code instead
    phone = request.form.get('phone')
    v_status = request.form.get('v_status')
    p_status = request.form.get('p_status')
    
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT role FROM users WHERE username = %s", [session['username']])
    user_role = cursor.fetchone()
    if user_role and user_role[0] == 'w':
        
        try:
            cursor = mysql.connection.cursor()
            cursor.callproc('new_criminal', [last, first, street, city, state, zip_code, phone, v_status, p_status])
            mysql.connection.commit()
            flash('Criminal record added successfully!')
        except Exception as e:
            flash(f'Error adding criminal record: {e}')
        finally:
            cursor.close()

        return redirect(url_for('view_criminals'))
    else:
        flash('You do not have permission to perform this action.')
        return redirect(url_for('index.html'))


@app.route('/search_criminals', methods=['POST'])
def search_criminals():
    if 'username' not in session:
        return redirect(url_for('login'))

    data = request.get_json()
    if not data or 'criminal_id' not in data:
        return jsonify({'error': 'No criminal_id provided'}), 400

    criminal_id = data['criminal_id']
    
    try:
        # Fetching data for various aspects related to the crime
       
        criminals = runstatement("SELECT * FROM Criminals WHERE Criminal_ID = %s", [criminal_id]).to_dict(orient='records')
        crime_details = runstatement("SELECT * FROM Crimes WHERE Criminal_ID = %s", [criminal_id]).to_dict(orient='records')
        alias = runstatement("SELECT * FROM Alias WHERE Criminal_ID = %s", [criminal_id]).to_dict(orient='records')
        sentence = runstatement("SELECT * FROM Sentences WHERE Criminal_ID = %s", [criminal_id]).to_dict(orient='records')

        # Combining all results in a dictionary
        results = {
            'criminals': criminals,
            'crimes': crime_details,
            'alias': alias,
            'sentence': sentence,
        }
        return jsonify(results) 
    except Exception as e:
        print(f"An error occurred: {e}")
        return render_template('error.html', error=str(e))

@app.route('/update_v_status', methods=['POST'])
def update_v_status():
    if 'username' not in session:
        return redirect(url_for('login'))

    criminal_id = request.form['criminal_id']
    v_status = request.form['v_status']

    try:
        cursor = mysql.connection.cursor()
        sql = "UPDATE Criminals SET V_status = %s WHERE Criminal_ID = %s"
        cursor.execute(sql, (v_status, criminal_id))
        mysql.connection.commit()
        return redirect(url_for('view_criminals'))
    except Exception as e:
        mysql.connection.rollback()
        return jsonify({'error': str(e)}), 500

@app.route('/update_p_status', methods=['POST'])
def update_p_status():
    if 'username' not in session:
        return redirect(url_for('login'))

    criminal_id = request.form['criminal_id']
    p_status = request.form['p_status']

    try:
        cursor = mysql.connection.cursor()
        sql = "UPDATE Criminals SET P_status = %s WHERE Criminal_ID = %s"
        cursor.execute(sql, (p_status, criminal_id))
        mysql.connection.commit()
        return redirect(url_for('view_criminals'))
    except Exception as e:
        mysql.connection.rollback()
        return jsonify({'error': str(e)}), 500
    

@app.route('/delete_criminal', methods=['POST'])
def delete_criminal():
    if 'username' not in session:
        return redirect(url_for('login'))

    criminal_id = request.form.get('criminal_id')
    if not criminal_id or not criminal_id.isdigit():
        return jsonify({'error': 'Invalid Criminal ID'}), 400  # Ensuring it is a digit

    try:
        cursor = mysql.connection.cursor()
        cursor.execute("DELETE FROM Sentences WHERE Criminal_ID = %s", [criminal_id])
        cursor.execute("DELETE FROM Alias WHERE Criminal_ID = %s", [criminal_id])
        cursor.execute("DELETE FROM Crimes WHERE Criminal_ID = %s", [criminal_id])
        cursor.execute("DELETE FROM Criminals WHERE Criminal_ID = %s", [criminal_id])
        mysql.connection.commit()
        return redirect(url_for('view_criminals'))
    except Exception as e:
        mysql.connection.rollback()
        return jsonify({'error': str(e)}), 500


@app.route('/view_crimes')
def view_crimes():
    if 'username' not in session:
        return redirect(url_for('login'))
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT role FROM users WHERE username = %s", [session['username']])
    role = cursor.fetchone()

    df = runstatement("SELECT * FROM `Crimes`")
    # Convert DataFrame to a list of dictionaries for easier template processing
    crimes_list = df.to_dict(orient='records')
    
    return render_template('view_crimes.html', crimes=crimes_list,role=role[0])



@app.route('/report_crime', methods=['POST'])
def report_crime():
    if 'username' not in session:
        return redirect(url_for('login'))
    criminal_id = int(request.form.get('criminal_id'))
    classification = request.form.get('classification')
    date_charged = request.form.get('date_charged')
    crime_status = request.form.get('crime_status')
    hearing_date = request.form.get('hearing_date')
    appeal_cut_date = request.form.get('appeal_cut_date')
    logging.warning('Attempting to log new crime')

    try:
        cursor = mysql.connection.cursor()
        # First check if the criminal_id exists in the Criminals table
        cursor.execute("SELECT COUNT(1) FROM Criminals WHERE Criminal_ID = %s", (criminal_id,))
        if cursor.fetchone()[0]:
            # If the criminal exists, then proceed to call the procedure
            cursor.callproc('new_crime', [criminal_id, classification, date_charged, crime_status, hearing_date, appeal_cut_date])
            mysql.connection.commit()
            logging.warning('New crime reported successfully')
            flash('Crime reported successfully!')
        else:
            flash('No such criminal ID exists.')
            logging.warning('Failed to report crime: No such criminal ID exists')
    except Exception as e:
        mysql.connection.rollback()
        flash(f'Error reporting crime: {e}')
        logging.error(f'Error reporting crime: {e}')
    finally:
        cursor.close()
    return redirect(url_for('view_crimes'))


@app.route('/view_officers')
def view_officers():
    if 'username' not in session:
        return redirect(url_for('login'))
    cursor = mysql.connection.cursor()
    cursor.execute("SELECT role FROM users WHERE username = %s", [session['username']])
    role = cursor.fetchone()
    df = runstatement("SELECT * FROM `officers`")
    # Convert DataFrame to a list of dictionaries for easier template processing
    officer_list = df.to_dict(orient='records')
    return render_template('view_officers.html', officers=officer_list, role=role[0])

@app.route('/add_officer', methods=['POST'])
def add_officer():
    if 'username' not in session:
        return redirect(url_for('login'))
   
    try:
        Last_name = request.form['last_name']
        First_name = request.form['first_name']
        Precinct = request.form['precinct']
        Badge = request.form['badge']
        Phone = request.form['phone']
        Officer_status = request.form['officer_status']

        logging.warning('Processing adding new officer')
        cursor = mysql.connection.cursor()
        cursor.callproc('new_officer', [Last_name, First_name, Precinct, Badge, Phone, Officer_status])
        mysql.connection.commit()
        flash('Officer added successfully!')
    except Exception as e:
        mysql.connection.rollback()
        logging.error(f'Error adding officer: {e}')
        flash(f'Error adding officer: {e}')
    finally:
   
        cursor.close()
    return redirect(url_for('view_officers'))

@app.route('/search_crime', methods=['POST'])
def search_crime():
    if 'username' not in session:
        return redirect(url_for('login'))

    data = request.get_json()
    if not data or 'crime_id' not in data:
        return jsonify({'error': 'No crime_id provided'}), 400

    crime_id = data['crime_id']
    
    try:
        # Fetching data for various aspects related to the crime
        crime_details = runstatement("SELECT * FROM Crimes WHERE Crime_ID = %s", [crime_id]).to_dict(orient='records')
        criminals = runstatement("SELECT * FROM Criminals WHERE Criminal_ID IN (SELECT Criminal_ID FROM Crimes WHERE Crime_ID = %s)", [crime_id]).to_dict(orient='records')
        officers = runstatement("SELECT * FROM Officers WHERE Officer_ID IN (SELECT Officer_ID FROM Crime_Officers WHERE Crime_ID = %s)", [crime_id]).to_dict(orient='records')
        appeals = runstatement("SELECT * FROM Appeals WHERE Crime_ID = %s", [crime_id]).to_dict(orient='records')
        charges = runstatement("SELECT * FROM Crime_Charges WHERE Crime_ID = %s", [crime_id]).to_dict(orient='records')

        # Combining all results in a dictionary
        results = {
            'crimes': crime_details,
            'criminals': criminals,
            'officers': officers,
            'appeals': appeals,
            'charges': charges
        }
        return jsonify(results) 
    except Exception as e:
        print(f"An error occurred: {e}")
        return render_template('error.html', error=str(e))


@app.route('/whoarewe')
def who_are_we():
    
    return render_template('whoarewe.html')

@app.route('/gethelp')
def get_help():
    return render_template('gethelp.html')

@app.route('/addtodb')
def add_to_db():
    return render_template('addtodb.html')

## to send email from help page
@app.route('/send_email', methods=['POST'])
def send_email():
    from_email = request.form['from_email']
    to_email = "kg3354@nyu.edu"
    subject = request.form['subject']
    message = request.form['message']
    sendEmail(from_email, to_email, subject, message)
    return render_template('gethelp.html', message="Email sent successfully!")

def sendEmail(from_email, to_email, subject, message):
    mailserver = "216.165.61.12"
    serverPort = 25
    clientSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    clientSocket.connect((mailserver, serverPort))
    
    clientSocket.recv(1024).decode()

    # HELLO Command
    clientSocket.send('HELO Alice\r\n'.encode())
    clientSocket.recv(1024).decode()

    # MAIL FROM
    mailFromCommand = 'MAIL FROM: <{}>\r\n'.format(from_email)
    clientSocket.send(mailFromCommand.encode())
    clientSocket.recv(1024).decode()

    # RCPT TO
    rcptToCommand = 'RCPT TO: <{}>\r\n'.format(to_email)
    clientSocket.send(rcptToCommand.encode())
    clientSocket.recv(1024).decode()

    # DATA
    clientSocket.send('DATA\r\n'.encode())
    clientSocket.recv(1024).decode()

    # Email content
    now = datetime.now()
    current_time = now.strftime("%H:%M:%S")
    full_message = (
        'Subject: {}\r\n'
        'From: {}\r\n'
        'To: {}\r\n'
        '\r\n'
        '{}\r\n\r\n'
        'Sent at: {}\r\n'
        ).format(subject, from_email, to_email, message, current_time)
    clientSocket.send(full_message.encode())

    # End the email
    clientSocket.send('\r\n.\r\n'.encode())
    clientSocket.recv(1024).decode()

    # QUIT
    clientSocket.send('QUIT\r\n'.encode())
    clientSocket.recv(1024).decode()
    clientSocket.close()


if __name__ == '__main__':
    app.run(host='192.168.150.1', port=8080, debug=True)