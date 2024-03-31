#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# Display all services
DISPLAY_SERVICES() {
  ALL_SERVICES=$($PSQL "select service_id, name from services;")

  # if no services
  if [[ -z $ALL_SERVICES ]]
  then
    echo -e "\nNo services data"
  else
    echo "$ALL_SERVICES" | while read SERVICE_ID BAR NAME
    do
      echo "$SERVICE_ID) $NAME"
    done
  fi
}


while true; do
  DISPLAY_SERVICES

  echo -e "\nWhat is your service_id ?"
  read SERVICE_ID_SELECTED

  # if not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    echo -e "\nService id should be a number."
  else
    SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED;")

    if [[ -z $SERVICE_NAME ]]
    then
      echo -e "\nInvalid service id. Please select a valid service_id."
    else
      break
    fi
  fi
done

echo -e "\nEnter your phone:"
read CUSTOMER_PHONE

# Check if the customer exists
PHONE_EXISTING=$($PSQL "select phone from customers where phone='$CUSTOMER_PHONE';")
if [[ -z $PHONE_EXISTING ]]
then
  echo -e "\nEnter the customer name:"
  read CUSTOMER_NAME

  # Insert customer information into the customers table
  INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers (name, phone) values ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")

  # Get customer_id inserted
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")

  echo -e "\nEnter the service time:"
  read SERVICE_TIME

  INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments (customer_id, service_id, time) values ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

else
  echo -e "\nPhone number is already used."
fi
