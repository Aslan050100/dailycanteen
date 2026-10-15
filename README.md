# Daily Canteen — сайт-визитка (dailycanteen.kz)

Статический сайт ТОО «Daily Canteen» (БИН 200140012296), бренд Rabbit Canteen.
Основная цель — верификация компании в Meta Business Manager для WhatsApp Business API.

Языки: русский (корень), казахский (`kk/`), английский (`en/`).

## Загрузка на хостинг

1. В панели хостинга откройте «Файловый менеджер» и папку сайта dailycanteen.kz
   (обычно `public_html`, `www` или `dailycanteen.kz/public_html`). Удалите заглушку хостинга (index.html / index.php по умолчанию).
2. Загрузите туда всё содержимое этого репозитория, кроме `.git` и `README.md`:
   `index.html`, `privacy.html`, `kk/`, `en/`, `assets/`, `robots.txt`, `sitemap.xml`, `.htaccess`.
   Файл `index.html` должен лежать прямо в корневой папке сайта, а не во вложенной.
3. Включите SSL-сертификат Let's Encrypt для dailycanteen.kz и www.dailycanteen.kz.
4. Когда https://dailycanteen.kz открывается без ошибки, раскомментируйте в `.htaccess`
   две строки перенаправления на HTTPS.

## Meta (Facebook)

- Подтверждение домена: Business Manager → Настройки компании → Безопасность бренда → Домены → добавить dailycanteen.kz.
  Выберите способ «мета-тег» и вставьте тег в `<head>` файла `index.html` (место отмечено комментарием) или добавьте TXT-запись в DNS.
- Данные компании в Business Manager вводите точно как в справке о регистрации.
