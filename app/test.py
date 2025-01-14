"""
This file contains tests for the server. It uses the requests library to make requests
to the server and compare the response to the expected value. The tests are run using
the unittest library.
"""

from sys import argv
from unittest import TestCase
import requests

tc = TestCase()
PORT = argv[1] if len(argv) > 1 else "8000"
ROOT_URL = f"http://localhost:{PORT}"


def assert_equal(a, b, msg=None):
    """Wrapper for unittest.TestCase().assert"""
    tc.assertEqual(a, b, msg)


def url(path, method="GET", data=None, err=False):
    """Make a request to the server"""
    response = requests.request(method, f"{ROOT_URL}{path}", json=data, timeout=2)
    if not err:
        if response.status_code == 500:
            print(response.text)
        response.raise_for_status()
    return response


def assert_response(path, expected, method="GET", data=None, msg=None):
    """Make a request to the server and compare the response to the expected value"""
    response = url(path, method, data)
    assert_equal(response.json(), expected, msg)


def test():
    """Run the tests"""
    response = url("/api/debug/db_drop", "POST")
    response = url("/")
    assert "/setup_db.html" in response.url
    assert (
        response.text.find("'/setup_db.html', { method: 'POST' }") != -1
    ), response.text
    url("/setup_db.html", "POST")
    response = url("/")
    assert (
        response.text.find("'/setup_db.html', { method: 'POST' }") == -1
    ), response.text

    assert_response(
        "/api/debug/hello",
        {"Hello": "World"},
        msg=f"Debug Hello World (504 = DB error) {ROOT_URL}/api/debug/hello",
    )
    assert_response(
        "/api/debug/db",
        {"db_test": 1},
        msg=f"Debug DB connection {ROOT_URL}/api/debug/db",
    )
    assert_equal(
        url("/api/debug/error", err=True).text.rsplit("\n", 2)[-2],
        "Exception: Test error",
        msg=f"Debug error middleware {ROOT_URL}/api/debug/error",
    )
    assert_equal(
        url("/").text.split("\n", 1)[0],
        "<!DOCTYPE html>",
        msg=f"Static files {ROOT_URL}/",
    )
    assert_response(
        "/api/db/nauczyciel",
        [],
        msg="GET nauczyciel {ROOT_URL}/api/db/nauczyciel",
    )
    assert url("/api/db/nauczyciel", "POST", {"imie": "Jan", "nazwisko": "Kowalski"}).ok
    assert_response(
        "/api/db/nauczyciel",
        [{"nauczyciel_id": 1, "imie": "Jan", "nazwisko": "Kowalski"}],
        msg="GET nauczyciel {ROOT_URL}/api/db/nauczyciel",
    )
    assert_response(
        "/api/db/nauczyciel/1",
        {"nauczyciel_id": 1, "imie": "Jan", "nazwisko": "Kowalski"},
        msg="GET nauczyciel/1 {ROOT_URL}/api/db/nauczyciel/1",
    )
    assert url("/api/db/nauczyciel/1", "PUT", {"nazwisko": "Nowak"}).ok
    assert_response(
        "/api/db/nauczyciel/1",
        {"nauczyciel_id": 1, "imie": "Jan", "nazwisko": "Nowak"},
        msg="GET nauczyciel/1 {ROOT_URL}/api/db/nauczyciel/1",
    )
    assert url("/api/db/nauczyciel/1", "DELETE").ok
    assert_response(
        "/api/db/nauczyciel",
        [],
        msg="GET nauczyciel {ROOT_URL}/api/db/nauczyciel",
    )


test()
print("All tests passed.")
