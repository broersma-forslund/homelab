<?php
$CONFIG = array (
    'allow_local_remote_servers' => true,
    'trusted_proxies' => array(
        0 => '127.0.0.1',
        1 => '10.244.0.0/16',
    ),
    'htaccess.RewriteBase' => '/',
    'forwarded_for_headers' => array('HTTP_X_FORWARDED_FOR'),
);
