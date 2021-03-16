<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'omar' );

/** MySQL database password */
define( 'DB_PASSWORD', 'password' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'g?eM+xF&K&kABJ,KFJhb-5Lm#k?@~?A249ke#L-U<aQ.T4RO<7WrksO R=)+fc_k');
define('SECURE_AUTH_KEY',  'hFk_F~O3}G&S]?N21S&] IAm7l-:-)L,g2-ZD?#e`vn3LNxceo}6S E0<iqA e%n');
define('LOGGED_IN_KEY',    '+7C65;xbR:o~?L0qLCK(>c&q2B)rJa6xY+i |,3t`d3G1+*sH|+LETlLUM8rSJg+');
define('NONCE_KEY',        'OwtjA^bO}?q.7!,R&7Evd_o?_> ^c=@|XcUm W~*B0N8l;R^|-Ex[JT[(a1&SsCL');
define('AUTH_SALT',        'Xl(u-MGzjp|RwU+gV&RQLBKsaafk9n1U+]AC8OfwJa9{E?[S|4@]CtW<+.kdRg*+');
define('SECURE_AUTH_SALT', '(Y1jBX`l, >GT{Khu{0}&d&]+=ML(v8b)QD,jQ;5R+|no@n#k-TIbxV=;.Vk(_O*');
define('LOGGED_IN_SALT',   '>t7yC3FB1y6q|g=pdi+[lRwi]|?V/f!07PkkZ5t}@+Je]IaV_Oq5Hp,f~45E Wn>');
define('NONCE_SALT',       '6LgnR=fYr._sW@C9F-I-9 UMq$@n?&2o7>z)a%P<g43^tbMJP]kh;gU@vbb{h[s4');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';