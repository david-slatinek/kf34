#!/bin/bash

email="email"

{
  echo "From: ${email}"
  echo "To: ${email}"
  echo -e "Subject: ECG result\n"
  echo "<img src='data:image/png;base64, $(base64 -w 64 image.png)' />"
  echo -e "\nDate: $(date +'%d.%m.%Y %T')"
} >>content_email.txt

curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
  --mail-from "${email}" --mail-rcpt "${email}" \
  -ns -T content_email.txt

rm content_email.txt
rm image.png
