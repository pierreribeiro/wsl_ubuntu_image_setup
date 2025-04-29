# wsl_image_setup

## Introduction

This code is leveraged to standup WSL Images for Distribution

## Requirements

* WSL2 be installed on windows machine
* Running code from Ubuntu Distribution
* Initial DNS Settings Have Been Updated
* Windows Network Interface Metrics Are Set Properly

## Usage example

```bash
ansible-playbook init.yml
```

## Maintained by IaC Community

## TODO

1) Criar uma role para =>
    a) pipx install ansible-dev-tools e pipx ensurepath a ser executada pelo usuário não root OK FEITO

2) Na role add_fix_script editar o template fix.sh.j2 e:   OK FEITO
    a) Ajustar ou retirar código referente a ansible-navigator - linha 42 adiante
    b) Ajustar ou retirar código referente a /etc/resolv.conf (não é mais necessário colocar nameserver estárico) - linha 6 adiante

3) Na role wsl_network_setup editar main.yml e:     OK FEITO
    a) retirar código que manipula /etc/resolv.conf

4) Na role wsl_network_setup editar wsl.conf.j2 e:      OK FEITO
    a) Retirar [network]
               generateResolvConf = false
    b) Adicionar [boot]
                systemd=true
    c) Manter # Set the user when launching a distribution with WSL.
              [user]
              default = {{ v_wsl_network_setup_username }}
    d) Adicionar [interop]
                 appendWindowsPath=false

5) Remover a role install_ansible_navigator OK FEITO

6) Editar o arquivo init.yml e: OK FEITO
    a) remover referências a role install_ansible_navigator
    b) criar referências a role ansible-dev-tools

7) Na role vs_code_setup criar um template com:
    a) {
            "ansible.ansible.reuseTerminal": true,
            "ansible.python.interpreterPath": "/home/{{ v_vs_code_setup_username }}/.local/share/pipx/venvs/ansible-dev-tools/bin/python3",
            "ansible.ansibleNavigator.path": "/home/{{ v_vs_code_setup_username }}/.local/share/pipx/venvs/ansible-dev-tools/bin/ansible-navigator",
            "ansible.validation.lint.path": "/home/{{ v_vs_code_setup_username }}/.local/share/pipx/venvs/ansible-dev-tools/bin//ansible-lint"
            "files.associations": {
                    "**/*.yml": "ansible",
                    "**/*.yaml": "ansible"
            }
        }

8) Na role vs_code_setup editar settings.json e inserir com o resultado do template gerado.
