from flask import Flask, render_template
import mysql.connector
import os

app = Flask(__name__)

db_config = {
    "host": "localhost",
    "user": "root",
    "password": "password123",
    "database": "studentdb"
}


@app.route("/")
def index():
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()
    cursor.execute("SELECT id, name, course FROM students")
    students = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template("index.html", students=students)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
