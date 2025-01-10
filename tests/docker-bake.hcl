variable "CASES" {
  default = {
    py314t = {pass="py314t py313t py314 py313 py312 py311 py310 py39 py38", fail="py37 py36 py35 py27"},
    py313t = {pass="py314t py313t py314 py313 py312 py311 py310 py39 py38", fail="py37 py36 py35 py27"},
    py314 = {pass="py314t py313t py314 py313 py312 py311 py310 py39 py38", fail="py37 py36 py35 py27"},
    py313 = {pass="py314t py313t py314 py313 py312 py311 py310 py39 py38 py37 py36 py35 py27", fail=""},
    py312 = {pass="py314t py313t py314 py313 py312 py311 py310 py39 py38", fail="py37 py36 py35 py27"},
    py311 = {pass="py314t py313t py314 py313 py312 py311 py310 py39 py38", fail="py37 py36 py35 py27"},
    py310 = {pass="py314t py313t py314 py313 py312 py311 py310 py39 py38", fail="py37 py36 py35 py27"},
    py39 = {pass="py314t py313t py314 py313 py312 py311 py310 py39 py38", fail="py37 py36 py35 py27"},
    py38 = {pass="py314t py313t py314 py313 py312 py311 py310 py39 py38", fail="py37 py36 py35 py27"},
    py37 = {pass="py314t py313t py314 py313 py312 py311 py310 py39 py38 py37", fail="py36 py35 py27"},
    py36 = {fail="py314t py313t py314 py313 py312", pass="py311 py310 py39 py38 py37 py36 py35 py27"},
    py35 = {fail="py314t py313t py314 py313 py312", pass="py311 py310 py39 py38 py37 py36 py35 py27"},
    py27 = {fail="py314t py313t py314 py313 py312", pass="py311 py310 py39 py38 py37 py36 py35 py27"},
  }
}

target "default" {
  dockerfile = "tests/Dockerfile"
  context = "."
  args = {
    CASE_NAME = CASE,
    TOX_TAG = CASE,
    TAGS_PASSING = CASES[CASE]["pass"],
    TAGS_INVALID = CASES[CASE]["fail"],
    TAGS_NOTFOUND = "py20",  # always missing in multipython
  }
  matrix = {
    CASE = keys(CASES)
  }
  name = "test_${CASE}"
  output = ["type=cacheonly"]
}
