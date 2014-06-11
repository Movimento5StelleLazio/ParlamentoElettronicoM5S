1. Modify your /etc/mime.type -> "text/css css less"

2. Enable mod_expire:
# ln -s /etc/lighttpd/conf-available/10-expire.conf /etc/lighttpd/conf-enabled/10-expire.conf

3. Set env to "production" in app/main/_layout/custom.html

