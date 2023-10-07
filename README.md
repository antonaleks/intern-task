# Краткий гайд для проверяющих :) 
## Terraform
Чтобы не возиться с переменными можно сразу создать файл `set_vars.sh` (необязательно)

1. Зайти в папку terraform 
2. Создать файл `set_vars.sh` следующего вида (необязательно) со следующим содержанием (Не забудьте экранировать спец. символы !!!):
```bash
#!/bin/bash
export TF_VAR_domain_name={{domain_name}}
export TF_VAR_tenant_id={{tenant_id}}
export TF_VAR_user_name={{user_name}}
export TF_VAR_password={{password}}
export TF_VAR_region={{region}}
export TF_VAR_access_key={{access_key}}
export TF_VAR_secret_key={{secret_key}}
```
3. Запустить команду (необязательно)
```bash
source set_vars.sh
```
4. Создать файл `backend.tfvars` со след. содержанием:
```
access_key={{access_key}}
secret_key={{secret_key}}
```
5. Создать пару публичный и приватный ssh ключей в `~/.ssh/id_rsa.pub` и `~/.ssh/id_rsa`
6. Запустить команду (не забыть включить перед этим VPN!)
```bash
terraform init -reconfigure -backend-config=backend.tfvars
```
7. Теперь можно задеплоить изменения
```bash
terraform apply
``` 

# Ansible

1. Зайти в папку ansible
2. Создать файл `db_access.yml` в папке `group_vars`:
```bash
ansible-vault create group_vars/db_access.yml
``` 
3. Содержание файла должно быть следующим:
```
MYSQL_DB: {DB_NAME}
MYSQL_PASSWORD: {DB_PASSWORD}
```

4. Запустить команду:
```
ansible-playbook playbook.yml --ask-vault-pass
```

# CloudPractice
Практическое задание для работы с terraform, ansible и облаком Selectel.

В данной практике необходимо создать инфраструктуру в проекте Selectel с помощью terraform и сконфигурировать веб-сервисы с помощью ansible
![img.png](assets/schema.png)

В качестве конечного приложения нужно использовать контейнер с todo и БД mysql. Смотри docker-compose файл ниже
![img.png](assets/todo-list-sample.png)

```yaml
version: "3.7"

services:
  app:
    image: antonaleks/101-todo-app
    ports:
      - 3000:80
    environment:
      MYSQL_HOST: mysql
      MYSQL_USER: root
      MYSQL_PASSWORD: secret
      MYSQL_DB: todos

  mysql:
    image: mysql:5.7
    volumes:
      - todo-mysql-data:/var/lib/mysql
    environment: 
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: todos

volumes:
  todo-mysql-data:
```

Нужно создать n=2 виртуальные машины, одну для todo app, другую для mysql DB.
## Terraform

в папке [terraform](terraform) вы найдете пример модуля для создания прерываемого сервера.

1. В провайдере openstack заполнить своими данными поля из excel таблицы
- domain_name = <domain>
- tenant_id   = <id проекта, см скриншот в источниках>
- user_name   = <логин>
- password    = <пароль>
- region      = <ru-7>
2. Будет плюсом использовать в качестве хранилища [terraform state S3](https://docs.selectel.ru/cloud/servers/tools/terraform/#настроить-хранение-terraform-state). Креды вам будут переданы отдельно. Для инициализации хранилища можно использовать команду `terraform init -reconfigure -backend-config=backend.tfvars`, где в файл backend.tfvars положить access_key, secret_key
2. Необходимо развернуть n количество ВМ с атрибутом прерываемый
2. Развернуть необходимые подсети
3. Создать публичный ssh ключ и приатачить к ВМ
4. Создать загружаемый диск с ubuntu 20.04
5. Создать flavor 1CPU 2 gb RAM, Диск объем 10гб на каждую вм (базовый hdd)
6. Для каждой ВМ зафиксировать публичный ip адрес
7. В output зафиксировать вывод ip адрес и команду ssh для подключения
8. Создать файл inventory.ini для ansible, где описаны айпи адреса созданных ВМ

В качестве примеров использовать [preempible_sever](terraform/main.tf) с модулями. Это готовый рабочий пример, который нужно правильно запустить

## Ansible

В директории [ansible](ansible) вы найдете шаблон, по которому можно составить плейбуки. Но это не является требованием, можно составлять плейбуки не опираясь на пример.
Требования к плейбуку:
- отдельная роль для установки докера
- отдельная роль для установки приложения

1. Использовать сгенерированный terraform'ом inventory файл
2. Написать плейбуки для развертывания ваших приложений в docker-compose файлах. [Примеры](https://github.com/antonaleks/ya-praktikum-infra/tree/main/ansible)
3. Приложение и база данных должны быть установлены на разных виртуальных машинах

## Как принимается работа
В итоге по запуску команд
```bash
terraform apply
```
должна сгенерироваться инфраструктура и inventory.ini

по запуску команд
```bash
ansible-playbook your-playbook.yml
```
должно установиться ваше приложение на инфрастуктуру автоматически. Критерием выполнения задания является доступность веб интерфейса в публичном ip адресе (todo-app)

## Раздел по безопасности
Ни в коем случае нельзя хранить в репозитории чувствительные данные! Работа не принимается, если в репозитории будут лежать логины, пароли от ВМ!

# Источники
- ресурсы опенстека в [terraform registry](https://terraform-eap.website.yandexcloud.net/docs/providers/openstack/index.html)
- откуда брать id проекта
![img.png](assets/id_project.png)
- документация [selectel](https://docs.selectel.ru/cloud/servers/tools/terraform/)
- [примеры selectel](https://github.com/selectel/terraform-examples) (terraform selectel provider использовать не нужно, только openstack)
- пример связки [terraform+ansible](https://github.com/antonaleks/ya-praktikum-infra). смотреть папку [terraform](https://github.com/antonaleks/ya-praktikum-infra/blob/main/terraform/sausage-store/main.tf) и [ansible](https://github.com/antonaleks/ya-praktikum-infra/tree/main/ansible)
