from pathlib import Path
import os
import venv


def setup_venv():
    root_venv_path = Path.home().joinpath('.env')
    root_venv_path.mkdir(parents=True, exist_ok=True)

    pip_cmd = (
        '. {source_path} &&'
        'pip3 install -r /workspaces/rds-backend/backend/requirements.txt'
    )

    venv_path = root_venv_path.joinpath('rds-backend')
    venv.create(venv_path, with_pip=True)

    source_path = venv_path.joinpath('bin/activate')
    os.system(pip_cmd.format(
        source_path=source_path,
    ))


if __name__ == '__main__':
    setup_venv()
