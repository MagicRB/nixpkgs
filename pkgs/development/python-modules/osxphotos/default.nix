{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  bitmath,
  bpylist2,
  click,
  mako,
  more-itertools,
  objexplore,
  packaging,
  pathvalidate,
  pip,
  ptpython,
  pytimeparse2,
  pyyaml,
  requests,
  rich-theme-manager,
  rich,
  shortuuid,
  strpdatetime,
  tenacity,
  textx,
  toml,
  wrapt,
  wurlitzer,
  xdg-base-dirs,

  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "osxphotos";
  version = "0.69.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "RhetTbull";
    repo = "osxphotos";
    tag = "v${version}";
    hash = "sha256-uVcoGIfxz+jKirnE3giST/v20eA5pq+LHgrsRb5b+Lc=";
  };

  build-system = [ setuptools ];
  dependencies = [
    bitmath
    bpylist2
    click
    mako
    more-itertools
    objexplore
    packaging
    pathvalidate
    pip
    ptpython
    pytimeparse2
    pyyaml
    requests
    rich-theme-manager
    rich
    shortuuid
    strpdatetime
    tenacity
    textx
    toml
    wrapt
    wurlitzer
    xdg-base-dirs
  ];

  pythonRelaxDeps = [
    "mako"
    "more-itertools"
    "objexplore"
    "textx"
    "tenacity"
  ];

  pythonImportsCheck = [ "osxphotos" ];
  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths = [ "tests/test_comments.py" ];
  disabledTests = [
    "test_iphoto_info"
    "test_from_to_date_tz"
    "test_function_url"
    "test_get_local_tz"
    "test_datetime_naive_to_local"
    "test_from_to_date_tz"
    "test_query_from_to_date_alt_location"
    "test_query_function_url"
  ];

  meta = {
    description = "Export photos from Apple's macOS Photos app and query the Photos library database to access metadata about images";
    homepage = "https://github.com/RhetTbull/osxphotos";
    changelog = "https://github.com/RhetTbull/osxphotos/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
