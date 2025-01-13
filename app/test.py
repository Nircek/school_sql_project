"""
This file contains tests for the server. It uses the requests library to make requests
to the server and compare the response to the expected value. The tests are run using
the unittest library.
"""

from unittest import TestCase
import requests

tc = TestCase()
ROOT_URL = "http://localhost:8000"


def assert_equal(a, b, msg=None):
    """Wrapper for unittest.TestCase().assert"""
    tc.assertEqual(a, b, msg)


def url(path, method="GET"):
    """Make a request to the server"""
    response = requests.request(method, f"{ROOT_URL}{path}", timeout=2)
    response.raise_for_status()
    return response


def assert_response(path, expected, method="GET", msg=None):
    """Make a request to the server and compare the response to the expected value"""
    response = url(path, method)
    assert_equal(response.json(), expected, msg)


assert_response(
    "/api/debug/hello",
    {"Hello": "World"},
    msg=f"Debug Hello World (504 = DB error) {ROOT_URL}/api/debug/hello",
)
assert_response(
    "/api/debug/db",
    {"db_test": [1]},
    msg=f"Debug DB connection {ROOT_URL}/api/debug/db",
)
assert_equal(
    url("/api/debug/error").text.rsplit("\n", 2)[-2],
    "Exception: Test error",
    msg=f"Debug error middleware {ROOT_URL}/api/debug/error",
)
assert_equal(
    url("/").text.split("\n", 1)[0], "<!DOCTYPE html>", msg=f"Static files {ROOT_URL}/"
)

print("All tests passed.")
