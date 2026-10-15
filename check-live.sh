#!/usr/bin/env bash
# Проверка живого сайта: коды ответов, редиректы, robots.txt, sitemap.xml, доступ роботов.
# Запуск: bash check-live.sh            (проверяет домен из этого файла)
#         bash check-live.sh example.kz (любой домен)
D="${1:-dailycanteen.kz}"
ok=0; bad=0
t(){ local name="$1" want="$2" got="$3"; if [[ "$got" == $want ]]; then echo "  OK    $name ($got)"; ok=$((ok+1)); else echo "  FAIL  $name: ждали $want, получили $got"; bad=$((bad+1)); fi; }
code(){ curl -s -o /dev/null -m 20 -A "${2:-Mozilla/5.0}" -w "%{http_code}" "$1"; }
loc(){ curl -s -o /dev/null -m 20 -w "%{http_code} %{redirect_url}" "$1"; }
echo "== Страницы (https://$D)"
for u in / /kk/ /en/ /privacy.html /kk/privacy.html /en/privacy.html /robots.txt /sitemap.xml /assets/og.jpg /assets/logo.png; do t "$u" 200 "$(code "https://$D$u")"; done
t "несуществующая страница -> 404" 404 "$(code "https://$D/net-takoy-stranicy")"
echo "== Редиректы"
t "http -> https" "301 https://$D/" "$(loc "http://$D/")"
t "www -> без www" "301 http*://$D/" "$(loc "https://www.$D/")"
t "/index.html -> /" "301 https://$D/" "$(loc "https://$D/index.html")"
echo "== Роботы (код ответа главной)"
for ua in "OAI-SearchBot|Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; OAI-SearchBot/1.3; +https://openai.com/searchbot" \
          "ChatGPT-User|Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; ChatGPT-User/1.0; +https://openai.com/bot" \
          "GPTBot|Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; GPTBot/1.1; +https://openai.com/gptbot" \
          "Googlebot|Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" \
          "YandexBot|Mozilla/5.0 (compatible; YandexBot/3.0; +http://yandex.com/bots)" \
          "bingbot|Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)" \
          "facebookexternalhit|facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)" \
          "ClaudeBot|Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; ClaudeBot/1.0; +claudebot@anthropic.com"; do
  t "${ua%%|*}" 200 "$(code "https://$D/" "${ua#*|}")"; done
echo "== robots.txt"
R=$(curl -s -m 20 "https://$D/robots.txt")
t "есть Sitemap" 1 "$(grep -c "^Sitemap: https://$D/sitemap.xml" <<<"$R")"
t "OAI-SearchBot разрешён" 1 "$(grep -A1 -x "User-agent: OAI-SearchBot" <<<"$R" | grep -c "^Allow: /")"
t "нет Disallow: /" 0 "$(grep -cx "Disallow: /" <<<"$R")"
echo "== Главная"
H=$(curl -s -m 20 "https://$D/")
t "canonical" 1 "$(grep -c "rel=\"canonical\" href=\"https://$D/\"" <<<"$H")"
t "meta robots index" 1 "$(grep -c 'name="robots" content="index' <<<"$H")"
t "schema.org JSON-LD" 1 "$(grep -c 'application/ld+json' <<<"$H")"
t "og:image" 1 "$(grep -c "og:image\" content=\"https://$D/" <<<"$H")"
t "сжатие gzip/br" "*" "$(curl -s -o /dev/null -D - -H 'Accept-Encoding: gzip, br' "https://$D/" | grep -i '^content-encoding' | tr -d '\r' || echo нет)"
echo; echo "Итого: OK $ok, FAIL $bad"
