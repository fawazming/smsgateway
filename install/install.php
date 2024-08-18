<?php

require_once __DIR__ . "/../vendor/autoload.php";
require_once __DIR__ . "/../includes/set-language.php";

if (isset($_POST["databaseServer"]) && isset($_POST["databaseName"]) && isset($_POST["databaseUser"]) && isset($_POST["databasePassword"])) {
    array_walk($_POST, 'trimByReference');

    $dbServer = $_POST["databaseServer"];
    $dbName = $_POST["databaseName"];
    $dbUser = $_POST["databaseUser"];
    $dbPassword = $_POST["databasePassword"];

    try {
        ob_start();
        $conn = new MysqliDb($dbServer, $dbUser, $dbPassword, $dbName);
        $conn->connect();
        $conn->startTransaction();
        require_once __DIR__ . "/migrations.php";
        $conn->multi_query($query);
        $secreteKey = random_str(24);
        $config = "<?php
define('DB_SERVER', '{$dbServer}');
define('DB_USER', '{$dbUser}');
define('DB_PASS', '{$dbPassword}');
define('DB_NAME', '{$dbName}');
define('TIMEZONE', '{$_POST["timezone"]}');
define('APP_SECRET_KEY', '{$secreteKey}');
define('APP_SESSION_NAME', 'SMS_GATEWAY');
";
        if (isset($_POST["purchaseCode"])) {
            $config .= "define('PURCHASE_CODE', '{$_POST["purchaseCode"]}');";
        }
        if (file_put_contents(__DIR__ . '/../config.php', $config)) {
            date_default_timezone_set($_POST["timezone"]);
            $user = new User();
            $user->setEmail(trim($_POST["email"]));
            if (!$user->read()) {
                $user->setApiKey(generateAPIKey());
                $user->setDateAdded(date('Y-m-d H:i:s'));
            }
            $user->setName(trim($_POST["name"]));
            $user->setPassword($_POST["password"]);
            $user->setIsAdmin(true);
            $user->save();
            Setting::apply(["firebase_service_account_json" => getFirebaseServiceAccountJson()]);
            if (file_exists(__DIR__ . "/../upgrade.php")) {
                if (!unlink(__DIR__ . "/../upgrade.php")) {
                    throw new Exception(__("error_removing_upgrade_script", ["type" => "Installation"]));
                }
            }
            $conn->commit();
            echo json_encode([
                'result' => __("success_installation")
            ]);
        } else {
            throw new Exception(__("error_creating_config"));
        }
    } catch (Exception $e) {
        ob_end_clean();
        echo json_encode([
            'error' => $e->getMessage()
        ]);
    }
}