#!/bin/bash

email="email"

{
  echo "From: ${email}"
  echo "To: ${email}"
  echo -e "Subject: Raspberry Pi sensor error\n"
  echo "Error: $1"
  echo "Date: $(date +'%d.%m.%Y %T')"
} >>content_email.txt

curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
  --mail-from "${email}" --mail-rcpt "${email}" \
  -ns -T content_email.txt

rm content_email.txt
