<?php

require 'vendor/autoload.php';
require 'aws_config.php';

use Aws\Sns\SnsClient;


$snsClient = new SnsClient([
    'version' => 'latest',
    'region'  => AWS_REGION,
    'credentials' => array(
        'key'    => AWS_ACCESS_KEY,
        'secret' => AWS_SECRET_KEY,
    ),
]);


$snsClient->publish(array(
    // 'TopicArn' => 'string',
    'TargetArn' => '送りたいエンドポイント(デバイス)のARN',
    // 'MessageStructure' => 'string',  // or 'json'
    // 'Message' => 'test message',
    // 'Subject' => 'test subject',
    'MessageStructure' => 'json',
    'Message' => json_encode(array(
        'APNS_SANDBOX' => json_encode(array(
            'aps' => array(
                'alert' => 'test message',
                'sound' => 'default',
                'badge' => 1
            ),
        )),
    ))
    // 'MessageAttributes' => array(
    //     // Associative array of custom 'String' key names
    //     'String' => array(
    //         // DataType is required
    //         'DataType' => 'string',
    //         'StringValue' => 'string',
    //         'BinaryValue' => 'string',
    //     ),
    //     // ... repeated
    // ),
));
