#!/usr/bin/env bash

HOST='localhost'
USERNAME='postgres'

psql -h $HOST -U $USERNAME -f ./cognicity.createdb.sql

psql -h $HOST -U $USERNAME -d 'cognicity' -f ../schema/cognicity/cognicity.schema.sql

psql -h $HOST -U $USERNAME -d 'cognicity' -f ../schema/cognicity/cognicity.functions.sql
