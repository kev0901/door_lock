from flask import Flask

app = Flask(__name__)

@app.route('/health')
def health():
    return ('Healthy!')

@app.route('/unlock')
def unlock():
    return ('Unlocked!')

if __name__ == '__main__':
    app.run()
