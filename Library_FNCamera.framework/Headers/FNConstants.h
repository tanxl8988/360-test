//
//  FNConstants.h
//  Library_FNCamera
//
//  Created by 楊凱丞 on 2015/12/1.
//  Copyright © 2015年 Choco Yang. All rights reserved.
//

#ifndef FNConstants_h
#define FNConstants_h

// Video Settings
#define TYPE_VIDEO_RESOLUTION           @"video_resolution"
#define TYPE_VIDEO_QUALITY              @"video_quality"
#define TYPE_VIDEO_TIMELAPSE            @"video_timelapse"
#define TYPE_VIDEO_TIMELAPSE_DURATION   @"video_timelapse_duration"
#define TYPE_VIDEO_SLOWMOTION           @"video_slowmotion"
#define TYPE_VIDEO_STAMP                @"video_stamp"
#define TYPE_VIDEO_STAMP_DATE           @"video_stamp_date"
#define TYPE_VIDEO_STAMP_TIME           @"video_stamp_time"
#define TYPE_VIDEO_STAMP_DRIVERID       @"video_stamp_driverid"
#define TYPE_VIDEO_HDR                  @"video_hdr"
#define TYPE_VIDEO_AUDIO                @"video_audio"
#define TYPE_VIDEO_MOTION_DET           @"video_motion_det"
#define TYPE_AUTO_RECORD                @"auto_record"
#define TYPE_VIDEO_CYCLIC               @"video_cyclic"
#define TYPE_LIVE_RESOLUTION            @"live_resolution"
#define TYPE_VIDEO_BITRATE              @"video_bitrate"
#define TYPE_LIVE_BITRATE               @"live_bitrate"
#define TYPE_PIP_STYLE                  @"pip_style"
#define TYPE_VIDEO_FISHEYE_MODE         @"video_fisheye_mode"
#define TYPE_VIDEO_WDR                  @"video_wdr"

// Photo Settings
#define TYPE_PHOTO_RESOLUTION           @"photo_resolution"
#define TYPE_PHOTO_QUALITY              @"photo_quality"
#define TYPE_PHOTO_TIMELAPSE            @"photo_timelapse"
#define TYPE_PHOTO_STAMP                @"photo_stamp"
#define TYPE_PHOTO_STAMP_DATE           @"photo_stamp_date"
#define TYPE_PHOTO_STAMP_TIME           @"photo_stamp_time"
#define TYPE_PHOTO_STAMP_DRIVERID       @"photo_stamp_driverid"
#define TYPE_CAPTURE_MODE               @"capture_mode"
#define TYPE_CONTINUE_SHOT              @"continue_shot"
#define TYPE_PHOTO_BURST                @"photo_burst"
#define TYPE_PHOTO_SELFTIMER            @"photo_selftimer"
#define TYPE_PHOTO_FISHEYE_MODE         @"photo_fisheye_mode"
#define TYPE_PHOTO_WDR                  @"photo_wdr"
#define TYPE_PHOTO_EV                   @"photo_ev"

// GPS Settings
#define TYPE_GPS                        @"gps"
#define TYPE_GPS_VOICE                  @"gps_voice"
#define TYPE_FCWS                       @"fcws"
#define TYPE_LDWS                       @"ldws"

// Other Settings
#define TYPE_MODE                           @"mode"
#define TYPE_FISHEYE_MODE                   @"fisheye_mode"
#define TYPE_STAMP                          @"stamp"
#define TYPE_EV                             @"ev"
#define TYPE_DUAL_STREAMS                   @"dual_streams"
#define TYPE_CAMERA_CLOCK                   @"camera_clock"
#define TYPE_CAMERA_DATE                    @"camera_date"
#define TYPE_CAMERA_TIME                    @"camera_time"
#define TYPE_WIFI                           @"wifi"
#define TYPE_WIFI_SSID                      @"wifi_ssid"
#define TYPE_WIFI_PASSWORD                  @"wifi_password"
#define TYPE_WIFI_ENABLE                    @"wifi_enable"
#define TYPE_WIFI_IP                        @"wifi_ip"
#define TYPE_DRIVERID                       @"driverid"
#define TYPE_AUTO_POWEROFF                  @"auto_poweroff"
#define TYPE_SENSOR_SENSITIVITY             @"sensor_sensitivity"
#define TYPE_TV_MODE                        @"tv_mode"
#define TYPE_FORMAT                         @"format"
#define TYPE_LANGUAGE                       @"language"
#define TYPE_CAMERA_RESET                   @"camera_reset"
#define TYPE_WIFI_RECONNECT                 @"wifi_reconnect"
#define TYPE_VIDEO_STREAM_TYPE              @"video_stream_type"
#define TYPE_STREAM_TYPE                    @"stream_type"
#define TYPE_FILE_PROTECT                   @"file_protect"
#define TYPE_WIFI_STATION                   @"wifi_station"
#define TYPE_WIFI_STATION_SSID              @"wifi_station_ssid"
#define TYPE_WIFI_STATION_PASSWORD          @"wifi_station_password"
#define TYPE_WIFI_STATION_TIMEOUT           @"wifi_station_timeout"
#define TYPE_WIFI_MODE                      @"wifi_mode"
#define TYPE_ZOOM_MAX                       @"zoom_max"
#define TYPE_ZOOM_CURRENT                   @"zoom_current"
#define TYPE_SENSOR_ROTATE                  @"sensor_rotate"
#define TYPE_BACK_SENSOR_ROTATE             @"back_sensor_rotate"
#define TYPE_SHARPNESS                      @"sharpness"
#define TYPE_COLOR                          @"color"
#define TYPE_ISO                            @"iso"
#define TYPE_WB                             @"wb"
#define TYPE_VOLUME                         @"volume"
#define TYPE_PARKING_MONITOR                @"parking_monitor"
#define TYPE_PARKING_MONITOR_EMR            @"parking_monitor_emr"
#define TYPE_BUTTON_SOUND                   @"button_sound"
#define TYPE_RECORDING_SETTING              @"recording_setting"
#define TYPE_HTTP_DOWNLOAD_PORT             @"http_download_port"
#define TYPE_HTTP_PLAYBACK_PORT             @"http_playback_port"
#define TYPE_VIDEO_DELAY_POWER_OFF          @"video_delay_power_off"
#define TYPE_VIDEO_EV                       @"video_ev"
#define TYPE_AUTO_SCREEN_POWEROFF           @"auto_screen_poweroff"
#define TYPE_UPDATE_FIRMWARE                @"update_firmware"
#define TYPE_LIGHT_FREQUENCY                @"light_frequency"
#define TYPE_RTMP_STREAM_ID                 @"rtmp_stream_id"
#define TYPE_RTMP_STREAM_ID_YOUTUBE         @"rtmp_stream_id_youtube"
#define TYPE_RTMP_STREAM_ID_FACEBOOK        @"rtmp_stream_id_facebook"
#define TYPE_RTMP_STREAM_ID_EASYLIVE        @"rtmp_stream_id_easylive"
#define TYPE_RTMP_ENABLE                    @"rtmp_enable"
#define TYPE_RTMP_STATUS                    @"rtmp_status"
#define TYPE_STREAM_CHANNEL                 @"stream_channel"
#define TYPE_GPS_TIMEZONE                   @"gps_timezone"
#define TYPE_SPEED_WARNING                  @"speed_warning"
#define TYPE_PIP_ENABLE                     @"pip_enable"
#define TYPE_BACK_EV                        @"back_ev"
#define TYPE_STAMP_ISO                      @"stamp_iso"
#define TYPE_BONJOUR_DISCOVERY_NAME         @"bonjour_discovery_name"
#define TYPE_POWER_VOICE                    @"power_voice"
#define TYPE_SOS                            @"sos"
#define TYPE_CHECK_AUTO_RECORD              @"check_auto_record"
#define TYPE_STAMP_GPS                      @"stamp_gps"
#define TYPE_P2P_ENABLE                     @"p2p_enable"
#define TYPE_P2P_UID                        @"p2p_uid"
#define TYPE_P2P_STATUS                     @"p2p_status"
#define TYPE_P2P_PASSWORD                   @"p2p_password"
#define TYPE_STITCHIMG_MODE                 @"stitching_mode"
#define TYPE_RTSP_TRANSPORT                 @"rtsp_transport"
#define TYPE_P2P_DOMAIN_OTUS                @"p2p_domain_otus"
#define TYPE_P2P_DOMAIN_OTUS_CHINA          @"p2p_domain_otus_china"
#define TYPE_SCREEN_BRIGHTNESS              @"screen_brightness"
#define TYPE_PUSH_NOTIFICATION              @"push_notification"
#define TYPE_DEVICE_LOCATION                @"device_location"
#define TYPE_WIFI_ONLINE_PALYBACK_ENABLE    @"wifi_online_playback_enable"
#define TYPE_WIFI_DOWNLOAD_FILE_ENABLE      @"wifi_download_file_enable"
#define TYPE_P2P_ONLINE_PALYBACK_ENABLE     @"p2p_online_playback_enable"
#define TYPE_P2P_DOWNLOAD_FILE_ENABLE       @"p2p_download_file_enable"
#define TYPE_GSENSOR_X                      @"gsensor_x"
#define TYPE_GSENSOR_Y                      @"gsensor_y"
#define TYPE_GSENSOR_Z                      @"gsensor_z"
#define TYPE_FILE_COVER                     @"file_cover"

// Settings Info
#define TYPE_STATUS                 @"status"
#define TYPE_CARD_STATUS            @"card_status"
#define TYPE_VIDEO_FREE             @"video_free"
#define TYPE_PHOTO_FREE             @"photo_free"
#define TYPE_CAMERA_FREE            @"camera_free"
#define TYPE_CAMERA_TOTAL           @"camera_total"
#define TYPE_BATTERY_LEVEL          @"battery_level"

// Setting Option Key
#define KEY_ERROR_CODE                                  @"errorCode"
#define KEY_TYPE                                        @"type"
#define KEY_PARAMETER                                   @"param"
#define KEY_PERMISSION                                  @"permission"
#define KEY_SETTINGINFOS                                @"settinginfos"
#define KEY_OPTIONS                                     @"options"
#define KEY_COUNT                                       @"count"
#define KEY_TOTAL                                       @"total"
#define KEY_DESCRIPTION                                 @"description"
#define KEY_RTSP_TRANSPORT                              @"rtsp_transport"
#define KEY_LIMIT_LENGTH                                @"limit_length"
#define KEY_LIMIT_CHARACTER                             @"limit_character"
#define KEY_ALLOW_EMPTY_PASSWORD                        @"allow_empty_password"
#define VALUE_PERMISSION_READONLY                       @"readonly"
#define VALUE_PERMISSION_SETTABLE                       @"settable"
#define VALUE_PERMISSION_MULTIPLE_SETTABLE              @"multiple_settable"
#define VALUE_PERMISSION_WRITEONLY                      @"setonly"
#define VALUE_FILE_NAME                                 @"name"
#define VALUE_FILE_PATH                                 @"path"
#define VALUE_FILE_DATE                                 @"date"
#define VALUE_FILE_SIZE                                 @"size"
#define VALUE_FILE_RESOLUTION                           @"resolution"
#define VALUE_FILE_DURATION                             @"duration"
#define VALUE_FILE_FRAMERATE                            @"framerate"
#define VALUE_FILE_PERMISSION                           @"permission"
#define VALUE_RTMP_TYPE_OFF                             @"off"
#define VALUE_RTMP_TYPE_YOUTUBE                         @"youtube"
#define VALUE_RTMP_TYPE_EASYLIVE                        @"easylive"
#define VALUE_RTMP_TYPE_FACEBOOK                        @"facebook"
#define VALUE_RTMP_STATUS_DISCONNECT                    @"disconnect"
#define VALUE_RTMP_STATUS_CONNECTING                    @"connecting"
#define VALUE_RTMP_STATUS_CONNECTED                     @"connected"
#define VALUE_RTMP_STATUS_RECONNECTING                  @"reconnecting"
#define VALUE_RTMP_STATUS_STREAMING_FAIL                @"streaming_fail"
#define VALUE_P2P_TYPE_OFF                              @"off"
#define VALUE_P2P_TYPE_OTUS                             @"otus"
#define VALUE_P2P_STATUS_DISCONNECT                     @"disconnect"
#define VALUE_P2P_STATUS_CONNECTING                     @"connecting"
#define VALUE_P2P_STATUS_CONNECTED                      @"connected"
#define VALUE_P2P_STATUS_RECONNECTING                   @"reconnecting"
#define VALUE_P2P_STATUS_CONNECT_FAIL                   @"connect_fail"
#define VALUE_PUSH_NOTIFICATION_TYPE_IOS_PRODUCT        @"ios_product"
#define VALUE_PUSH_NOTIFICATION_TYPE_IOS_DEVELOPMENT    @"ios_development"
#define VALUE_PUSH_NOTIFICATION_TYPE_ANDROID_GOOGLE     @"android_google"
#define VALUE_PUSH_NOTIFICATION_TYPE_ANDROID_BAIDU      @"android_baidu"

// Setting parameter key, these settings setSetting success has parameter.
// TYPE_WIFI、TYPE_WIFI_SSID、TYPE_WIFI_PASSWORD、TYPE_WIFI_STATION、TYPE_WIFI_STATION_SSID、
// TYPE_WIFI_STATION_PASSWORD、TYPE_WIFI_MODE、TYPE_WIFI_RECONNECT、TYPE_RTMP_ENABLE、TYPE_CAMERA_RESET
// TYPE_WIFI_ENABLE、TYPE_P2P_ENABLE
#define PARAM_COMPLETE                          @"complete"
#define PARAM_RESET_IMMEDIATE                   @"reset_immediate"
#define PARAM_RESET_AFTER_DISCONNECT            @"reset_after_disconnect"
#define PARAM_RESET_AFTER_CAMERA_WIFI_RESTART   @"reset_after_camera_wifi_restart"
#define PARAM_RESET_AFTER_CAMERA_RESTART        @"reset_after_camera_restart"


/*! P2PProxy module is not initialized yet. Please use P2PProxyServerInitialize() or P2PProxyClientInitialize() for initialization. */
#define OTUS_P2P_NOT_INITIALIZED                0x80000000

/*! The number of P2PProxy port mapping service has reached maximum. The maximum number of P2PProxy port mapping service is determined by P2PPROXY_MAX_PORT_MAPPING_SERVICE_NUMBER. */
#define OTUS_P2P_EXCEED_MAX_SERVICE             0x80000001

/*! Failed to start port mapping when binding because local port had been used by the other service in client side. */
#define OTUS_P2P_BIND_LOCAL_SERVICE             0x80000002

/*! Failed to start port mapping when listening because local port has been used by the other service in client side. */
#define OTUS_P2P_LISTEN_LOCAL_SERVICE           0x80000003

/*! P2PProxy module fails to create threads. Please check if system has ability to create threads for P2PProxy module. */
#define OTUS_P2P_FAIL_CREATE_THREAD             0x80000004

/*! Proxy client has already connected to a proxy server, therefore, it does not need to connect again. */
#define OTUS_P2P_ALREADY_CONNECTED              0x80000005

/*! The proxy between proxy client and proxy server has been disconnected. Used in proxy status callback function for notifying proxy connection status. */
#define OTUS_P2P_DISCONNECTED                   0x80000006

/*! The P2PProxy module has been initialized in a proxy server or a proxy client. */
#define OTUS_P2P_ALREADY_INITIALIZED            0x80000007

/*! The specified P2PProxy session ID is not valid */
#define OTUS_P2P_INVALID_SID                    0x80000008

/*! This UID is illegal. */
#define OTUS_P2P_UID_UNLICENSE                  0x80000009

/*! The specified device does not support advance function (TCP relay and P2PProxy module). */
#define OTUS_P2P_BIND_UID_NO_PERMISSION         0x80000010

/*! This UID can't setup connection through relay. */
#define OTUS_P2P_UID_NOT_SUPPORT_RELAY          0x80000011

/*! This UID can't setup connection through p2p. */
#define OTUS_P2P_UID_NOT_SUPPORT_P2P            0x80000012

/*! Proxy server not login to Register server. */
#define OTUS_P2P_DEVICE_NOT_ONLINE              0x80000013

/*! Proxy server is not listening for connection. */
#define OTUS_P2P_DEVICE_NOT_LISTENING           0x80000014

/*! Internet not available or firewall block. */
#define OTUS_P2P_NETWORK_UNREACHABLE            0x80000015

/*! Proxy client failed to connect to proxy server maybe network unstable. */
#define OTUS_P2P_FAILED_SETUP_CONNECTION        0x80000016

/*! Proxy server failed to login to Register server but still can be connected by proxy client on LAN. */
#define OTUS_P2P_LOGIN_FAILED                   0x80000017

/*! Notify proxy server session alreay reached maximum through P2PPROXYSERVERSTATUS_CALLBACK, can't be connected anymore until anyone session release. */
#define OTUS_P2P_EXCEED_MAX_SESSION             0x80000018

/*! Proxy client can't call P2PProxyServer_GetSessionInfo() */
#define OTUS_P2P_CLIENT_NOT_SUPPORT             0x80000019

/*! The arguments passed to a function is invalid. */
#define OTUS_P2P_INVALID_ARG                    0x80000020

/*! System resource not enough to malloc memory or open socket. */
#define OTUS_P2P_SYSTEM_RESOURCE_LACK           0x80000021

/*! Cannot resolve masters' host name. */
#define OTUS_P2P_FAIL_RESOLVE_HOSTNAME          0x80000022

/*! Fails to create Mutexs. */
#define OTUS_P2P_FAIL_CREATE_MUTEX              0x80000023

/*! Invalid callback function. */
#define OTUS_P2P_SETCALLBACK_NULL               0x80000024

/*! Fails to get DNS IP. */
#define OTUS_P2P_FAIL_GET_DNSIP                 0x80000025

/*! Fails to stop thread. */
#define OTUS_P2P_FAIL_STOP_THREAD               0x80000026

/*! Service protocol support TCP and UDP. */
#define OTUS_P2P_SERVICE_PROTOCOL_NOT_SUPPORT   0x80000027

/*! The specified P2PProxy port mapping index is not valid */
#define OTUS_P2P_INVALID_PORTMAPPING_INDEX      0x80000028

/*! The P2PProxy SDK between client and server is not compatible */
#define OTUS_P2P_SDK_INCOMPATIBLE               0x80000029

/*! This UID is already expired. */
#define OTUS_P2P_UID_EXPIRED                    0x80000030

/*! The specified P2PProxy optname is not valid */
#define OTUS_P2P_INVALID_OPTNAME                0x8000002a

/*! The specified P2PProxy opt is not valid */
#define OTUS_P2P_INVALID_OPT                    0x8000002b

/*! The specified P2PProxy connection expired */
#define OTUS_P2P_EXPIRED                        0x8000002c

/* p2pproxy encryption fail */
#define OTUS_P2P_ENCRYPT_FAILED                 0x8000002d

/* p2pproxy decryption fail */
#define OTUS_P2P_DECRYPT_FAILED                 0x8000002e

/* p2pproxy server already started */
#define OTUS_P2P_ALREADY_START                  0x8000002f

/* p2pproxy need authentication */
#define OTUS_P2P_NEED_AUTH                      0x10000007

/* p2pproxy authentication error */
#define OTUS_P2P_AUTH_ERROR                     0x10000008


typedef enum {
    DOWNLOADING = 0,
    DOWNLOADED = 1,
    DOWNLOAD_STOP = 2,
    DOWNLOAD_CANNOT_STOP = 3,
    DOWNLOAD_FILE_CREATE_FAIL = 4,
    DOWNLOAD_SOURCE_NOT_FOUND = 5,
    DOWNLOAD_NOT_SUPPORT = 6,
    DOWNLOAD_FAIL = 7,
    UPLOADING = 8,
    UPLOADED = 9,
    UPLOAD_STOP = 10,
    UPLOAD_CANNOT_STOP = 11,
    UPLOAD_SOURCE_NOT_FOUND = 12,
    UPLOAD_NOT_SUPPORT = 13,
    UPLOAD_FAIL = 14,
} FNDataTransferStatus;

typedef enum {
    ERROR_OK = 0,
    ERROR_UNDEFINED = -1,
    ERROR_NOT_SUPPORT = -2,
    ERROR_INVALID_TOKEN = -3,
    ERROR_COMMAND_TIMEOUT = -4,
    ERROR_SEND_COMMAND_ERROR = -5,
    ERROR_RECEIVED_COMMAND_ERROR = -6,
    ERROR_SESSION_START_FAIL = -7,
    ERROR_REACH_MAX_CLIENT = -8,
    ERROR_NO_MORE_SPACE = -9,
    ERROR_FILE_READ_ONLY = -10,
    ERROR_FILE_ERROR = -11,
    ERROR_INVALID_PATH = -12,
    ERROR_SYSTEM_BUSY = -13,
    ERROR_CARD_ERROR = -14,
    ERROR_CARD_REMOVED = -15,
    ERROR_FW_ERROR = -16,
    ERROR_HDMI_INSERTED = -17,
    ERROR_CONFIG_FILE_NOT_EXIST = -18,
    ERROR_DIR_EXIST = -19,
    ERROR_FOLDER_FULL = -20,
    ERROR_PERMISSION_DENIED = -21,
    ERROR_AUTHENTICATION_FAILED = -22,
    ERROR_DELETE_FAILED = -23,
    ERROR_BATTERY_LOW = -24,
    ERROR_PIV_NOT_ALLOWED = -25,
    ERROR_FORCE_STOP = -26,
    ERROR_READY_FOR_REBOOT = -27,
    ERROR_FILE_DOWNLOADING = -28,
    ERROR_MODE_ERROR = -29,
    ERROR_RECORDING_OPERATION = -30,
    ERROR_WIFI_DISABLED = -31,
    ERROR_RTMP_IS_ON = -32,
    ERROR_P2P_IS_ON = -33,
    ERROR_GATT_INVALID_HANDLE = -100,
    ERROR_GATT_READ_NOT_PERMIT = -101,
    ERROR_GATT_WRITE_NOT_PERMIT = -102,
    ERROR_GATT_INVALID_PDU = -103,
    ERROR_GATT_INSUF_AUTHENTICATION = -104,
    ERROR_GATT_REQ_NOT_SUPPORTED = -105,
    ERROR_GATT_INVALID_OFFSET = -106,
    ERROR_GATT_INSUF_AUTHORIZATION = -107,
    ERROR_GATT_PREPARE_Q_FULL = -108,
    ERROR_GATT_NOT_FOUND = -109,
    ERROR_GATT_NOT_LONG = -110,
    ERROR_GATT_INSUF_KEY_SIZE = -111,
    ERROR_GATT_INVALID_ATTR_LEN = -112,
    ERROR_GATT_ERR_UNLIKELY = -113,
    ERROR_GATT_INSUF_ENCRYPTION = -114,
    ERROR_GATT_UNSUPPORT_GRP_TYPE = -115,
    ERROR_GATT_INSUF_RESOURCE = -116,
    ERROR_GATT_NO_RESOURCES = -117,
    ERROR_GATT_INTERNAL_ERROR = -118,
    ERROR_GATT_WRONG_STATE = -119,
    ERROR_GATT_DB_FULL = -120,
    ERROR_GATT_BUSY = -121,
    ERROR_GATT_ERROR = -122,
    ERROR_GATT_CMD_STARTED = -123,
    ERROR_GATT_ILLEGAL_PARAMETER = -124,
    ERROR_GATT_PENDING = -125,
    ERROR_GATT_AUTH_FAIL = -126,
    ERROR_GATT_MORE = -127,
    ERROR_GATT_INVALID_CFG = -128,
    ERROR_GATT_SERVICE_STARTED = -129,
    ERROR_GATT_ENCRYPED_NO_MITM = -130,
    ERROR_GATT_NOT_ENCRYPTED = -131,
    ERROR_GATT_CONGESTED = -132,
    ERROR_GATT_CCC_CFG_ERR = -133,
    ERROR_GATT_PRC_IN_PROGRESS = -134,
    ERROR_GATT_OUT_OF_RANGE = -135,
    ERROR_GATT_KEYNOTFOUND = -136,
    ERROR_GATT_DECRYPTFAILURE = -137,
    ERROR_MAY_SYSTEM_PERMISSION_ERROR = -200,
} FNErrorCode;

typedef enum {
    NOTIFICATION_UNDEFINED = 0,
    NOTIFICATION_NEW_MW_STATE_PREVIEW = 1,
    NOTIFICATION_SESSION_DISCON_MANUAL_OP = 2,
    NOTIFICATION_RES_HDMI_INSERT = 3,
    NOTIFICATION_STORAGE_RUNOUT = 4,
    NOTIFICATION_STORAGE_IO_ERROR = 5,
    NOTIFICATION_MEMORY_RUNOUT = 6,
    NOTIFICATION_REACH_INDEX_LIMIT = 7,
    NOTIFICATION_REACH_FILE_LIMIT = 8,
    NOTIFICATION_CARD_REMOVED = 9,
    NOTIFICATION_CANNOT_ISSUE_PIV = 10,
    NOTIFICATION_BOSS_BOOT_READY = 11,
    NOTIFICATION_BOSS_NET_RECONNECTED = 12,
    NOTIFICATION_FW_UPGRADE_COMPLETE = 13,
    NOTIFICATION_GET_FILE_COMPLETE = 14,
    NOTIFICATION_PUT_FILE_COMPLETE = 15,
    NOTIFICATION_PUT_FILE_FAIL = 16,
    NOTIFICATION_DISCONNECT_HDMI = 17,
    NOTIFICATION_DISCONNECT_SHUTDOWN = 18,
    NOTIFICATION_STARTING_VIDEO_RECORD = 19,
    NOTIFICATION_VIDEO_RECORD_COMPLETE = 20,
    NOTIFICATION_PHOTO_TAKEN = 21,
    NOTIFICATION_CONTINUE_CAPTURE_START = 22,
    NOTIFICATION_CONTINUE_CAPTURE_STOP = 23,
    NOTIFICATION_CONTINUE_BURST_START = 24,
    NOTIFICATION_CONTINUE_BURST_COMPLETE = 25,
    NOTIFICATION_LOW_BATTERY_WARNING = 26,
    NOTIFICATION_LOW_STORAGE_WARNING = 27,
    NOTIFICATION_TIMELAPSE_VIDEO_STATUS = 28,
    NOTIFICATION_TIMELAPSE_PHOTO_STATUS = 29,
    NOTIFICATION_CAMERA_CONNECT_TO_PC = 30,
    NOTIFICATION_LOG_UPDATED = 31,
    NOTIFICATION_POWER_MODE_CHANGE = 32,
    NOTIFICATION_VF_START = 33,
    NOTIFICATION_VF_STOP = 34,
    NOTIFICATION_AUTO_FILE_DELETE = 35,
    NOTIFICATION_LOW_SPEED_CARD = 36,
    NOTIFICATION_QUERY_SESSION_HOLDER = 37,
    NOTIFICATION_MIC_ON = 38,
    NOTIFICATION_MIC_OFF = 39,
    NOTIFICATION_POWER_OFF = 40,
    NOTIFICATION_REMOVE_BY_USER = 41,
    NOTIFICATION_FILE_PROTECT_OFF = 42,
    NOTIFICATION_FILE_PROTECT_ON = 43,
    NOTIFICATION_AUTO_FILE_CYCLIC = 44,
    NOTIFICATION_CHANGE_PHOTO_MODE = 45,
    NOTIFICATION_CHANGE_VIDEO_MODE = 46,
    NOTIFICATION_CHANGE_PLAYBACK_MODE = 47,
    NOTIFICATION_CHANGE_PARKING_MONITOR_ON = 48,
    NOTIFICATION_CHANGE_PARKING_MONITOR_OFF = 49,
    NOTIFICATION_HEARTBEAT = 50,
    NOTIFICATION_DISCONNECT = 51,
    NOTIFICATION_LIVEVIEW_RESET = 52,
    NOTIFICATION_CARD_INSERTED = 53,
    NOTIFICATION_CARD_ERROR = 54,
    NOTIFICATION_BATTERY_LEVEL_CHANGED = 55,
    NOTIFICATION_PHOTO_SELFTIMER_COUNT = 56,
    NOTIFICATION_CAR_GO_FORWARD = 57,
    NOTIFICATION_CAR_GO_BACKWARD = 58,
    NOTIFICATION_VF_STOP_WITH_ACTION_COMPLETE = 59,
    NOTIFICATION_RECORD_FAIL = 60,
    NOTIFICATION_CHECK_AUTO_RECORD = 61,
    NOTIFICATION_REMIND_TO_STOP_DOWNLOAD_IN_LIVE_STREAMING = 62,
    NOTIFICATION_EVENT_FOLDER_FULL = 63,
    NOTIFICATION_WIFI_ON = 64,
    NOTIFICATION_WIFI_OFF = 65,
    NOTIFICATION_REFRESH_SETTING_LIST = 66,
} FNNotification;

#endif /* FNConstants_h */
