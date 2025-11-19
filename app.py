from flask import Flask, request, jsonify
from markupsafe import escape
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import JWTManager, create_access_token, jwt_required
import bcrypt
from datetime import timedelta

app = Flask(__name__)
app.config.from_object("config.Config")

db = SQLAlchemy(app)
jwt = JWTManager(app)


# User Model
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password_hash = db.Column(db.String(120), nullable=False)

    def set_password(self, password):
        self.password_hash = bcrypt.hashpw(
            password.encode("utf-8"), bcrypt.gensalt()
        ).decode("utf-8")

    def check_password(self, password):
        return bcrypt.checkpw(
            password.encode("utf-8"), self.password_hash.encode("utf-8")
        )


# Routes
@app.route("/auth/login", methods=["POST"])
def login():
    data = request.get_json()
    user = User.query.filter_by(username=escape(data.get("username"))).first()

    if user and user.check_password(data.get("password")):
        access_token = create_access_token(
            identity=str(user.id), expires_delta=timedelta(hours=1)
        )
        return jsonify(access_token=access_token)

    return jsonify({"error": "Invalid credentials"}), 401


@app.route("/api/data", methods=["GET"])
@jwt_required()
def get_data():
    # Example protected data
    return jsonify({"data": [escape(item) for item in ["Secret1", "Secret2"]]})


@app.route("/api/users", methods=["GET"])
@jwt_required()
def get_users():
    users = User.query.all()
    return jsonify([{"id": u.id, "username": escape(u.username)} for u in users])


if __name__ == "__main__":
    # Initialize DB
    with app.app_context():
        db.create_all()
        # Add test user
        if not User.query.filter_by(username="admin").first():
            user = User(username="admin")
            user.set_password("admin")
            db.session.add(user)
            db.session.commit()

    app.run(debug=True)
