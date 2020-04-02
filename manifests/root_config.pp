class cd4pe::root_config(
  String[1] $root_email,
  Sensitive[String[1]] $root_password,
  String[1] $resolvable_hostname                           = $cd4pe::resolvable_hostname,
  String[1] $agent_service_endpoint                        = "${resolvable_hostname}:${cd4pe::agent_service_port}",
  String[1] $backend_service_endpoint                      = "${resolvable_hostname}:${cd4pe::backend_service_port}",
  String[1] $web_ui_endpoint                               = "${resolvable_hostname}:${cd4pe::web_ui_port}",
  Enum['DISK', 'ARTIFACTORY', 'S3'] $storage_provider      = 'DISK',
  String[1] $storage_bucket                                = 'cd4pe',
  Optional[String[1]] $storage_endpoint                    = undef,
  Optional[String[1]] $storage_prefix                      = undef,
  Optional[String[1]] $s3_access_key                       = undef,
  Optional[Sensitive[String[1]]] $s3_secret_key            = undef,
  Optional[Sensitive[String[1]]] $artifactory_access_token = undef,
  Optional[Boolean] $ssl_enabled                           = undef,
  Optional[String[1]] $ssl_server_certificate              = undef,
  Optional[String[1]] $ssl_authority_certificate           = undef,
  Optional[Sensitive[String[1]]] $ssl_server_private_key   = undef,
  Optional[String[1]] $ssl_endpoint                        = undef,
  Optional[Integer] $ssl_port                              = 8443,
) inherits cd4pe {
  include cd4pe::anchors

  # If SSL is enabled, trigger a refresh of the CD4PE service on config update.
  # If SSL is not enabled, there's no need.
  $notify = $ssl_enabled ? {
    true    => Anchor['cd4pe-service-refresh'],
    default => undef,
  }

  cd4pe_root_config { $web_ui_endpoint:
    root_email                => $root_email,
    root_password             => $root_password,
    web_ui_endpoint           => $web_ui_endpoint,
    backend_service_endpoint  => $backend_service_endpoint,
    agent_service_endpoint    => $agent_service_endpoint,
    storage_provider          => $storage_provider,
    storage_endpoint          => $storage_endpoint,
    storage_bucket            => $storage_bucket,
    storage_prefix            => $storage_prefix,
    s3_access_key             => $s3_access_key,
    s3_secret_key             => $s3_secret_key,
    artifactory_access_token  => $artifactory_access_token,
    ssl_enabled               => $ssl_enabled,
    ssl_server_certificate    => $ssl_server_certificate,
    ssl_authority_certificate => $ssl_authority_certificate,
    ssl_server_private_key    => $ssl_server_private_key,
    ssl_endpoint              => $ssl_endpoint,
    ssl_port                  => $ssl_port,
    require                   => Anchor['cd4pe-service-install'],
    notify                    => $notify,
  }
}
