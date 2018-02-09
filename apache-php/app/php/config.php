<?php

/**
 * Configuration for database connection
 *
 */

$host       = DATABASE_HOST;
$username   = DATABASE_USER;
$password   = DATABASE_PASSWORD;
$dbname     = DATABASE_NAME;
$dsn        = "mysql:host=$host;dbname=$dbname";
$options    = array(
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
              );