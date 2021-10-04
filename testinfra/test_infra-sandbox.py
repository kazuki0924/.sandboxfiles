import pytest

@pytest.mark.parametrize("cmd", [
    "~/.pyenv/bin/pyenv -v",
    "~/.pyenv/shims/python -V"
])
def test_pyenv(host, cmd):
    assert host.run(cmd).succeeded

@pytest.mark.parametrize("name", [
    "az",
    "docker",
    "docker-compose"
])
def test_packages_exists(host, name):
    assert host.exists(name)
