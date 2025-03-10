from flask import Flask


def application_factory():
  app = Flask(__name__)

  @app.route('/')
  def hello():
    return "Hello, World!"

  return app
