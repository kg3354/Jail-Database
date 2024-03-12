from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/whoarewe')
def who_are_we():
    return render_template('whoarewe.html')

@app.route('/gethelp')
def get_help():
    return render_template('gethelp.html')


if __name__ == '__main__':
    app.run(debug=True)

