#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICE_ID_SELECTED=-1
while [[ $SERVICE_ID_SELECTED == -1 ]]
do
  SERVICES=$($PSQL "SELECT * FROM services;")

  echo -e "\nHere are the services we have available:"
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done
  
  echo "Choose a service:"
  read SERVICE_ID_SELECTED

  # if input is not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then
      echo "That is not a valid service ID."
      SERVICE_ID_SELECTED=-1
      continue
  fi

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  # service name empty
  if [[ -z $SERVICE_NAME ]]
    then
      echo "That is not a valid service ID."
      SERVICE_ID_SELECTED=-1
      continue
  fi
done

echo "Enter your phone number:"
read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
# customer name empty
if [[ -z $CUSTOMER_NAME ]]
  then
    echo "Enter your name:"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
fi

echo "Enter a time:"
read SERVICE_TIME

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE' AND name = '$CUSTOMER_NAME'" | sed "s/ //g")
echo "customer_id: $CUSTOMER_ID"
INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, time, service_id) VALUES ($CUSTOMER_ID, '$SERVICE_TIME', $SERVICE_ID_SELECTED);")

echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
