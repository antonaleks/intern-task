# Тестовое задание

Создание инфраструктуры в проекте Selectel с помощью Terraform, конфигурация веб-сервисов с помощью Ansible.

## Выполненное задание

Работу приложения, если сервера ещё не умерли, можно проверить [тут](http://5.35.4.229).

## Пошаговая инструкция

 1. Склонировать репозиторий
 2. В папке terraform создать файл backend.tfvars со следующим содержанием:
	```bash
	access_key = %ACCESS_KEY%
	secret_key = %SECRET_KEY%
	```
	Где вместо %ACCESS_KEY% и %SECRET_KEY% вписать свои значения
 3. Инициализировать хранилище S3:
	`terraform init -reconfigure -backend-config=backend.tfvars`
 4. Запустить Terraform:
	`terraform apply`
	Terraform попросит ввести данные от аккаунта, а также имя и пароль для базы данных
 5. В папке ansible установить необходимые Ansible-коллекции:
	`ansible-galaxy install -r requirements.yml`
 6. Запустить Ansible-плейбук:
	`ansible-playbook -i inventory.ini playbook.yml`
 7. Перейти по адресу, указанный в Terraform output как **Web App IP address**
