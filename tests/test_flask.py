import logging

import pytest
from flask import Flask

from example_app.app import application_factory

Application = application_factory()

Application.testing = True

@pytest.fixture
def app() -> Flask:
    return Application

def test_index(app):
    response = app.test_client().get('/')
    assert response.status_code == 200
    assert response.data == b"Hello, World!"
