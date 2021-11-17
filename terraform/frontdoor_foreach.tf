resource "azurerm_frontdoor" "frontdoor" {
  provider                                     = azurerm.dev
  name                                         = "fd-appservices"
  resource_group_name                          = azurerm_resource_group.resourcegroup.name
  enforce_backend_pools_certificate_name_check = false

  # Frontend endpoints
  frontend_endpoint {
    name      = "frontend-default"
    host_name = "fd-appservices.azurefd.net"
  }

  # Foreach app service setup routing, backend and probe
  dynamic "routing_rule" {
    for_each = { for t in local.json_data.appservices : t.name => t }

    content {
      name               = "routing-${routing_rule.value.id}"
      accepted_protocols = ["Http", "Https"]
      patterns_to_match  = [routing_rule.value.probe]
      frontend_endpoints = ["frontend-default"]

      forwarding_configuration {
        forwarding_protocol = "MatchRequest" # Protocol to use when redirecting. Valid options are HttpOnly, HttpsOnly, or MatchRequest
        backend_pool_name   = "backend-${routing_rule.value.id}"
        cache_enabled       = false
      }
    }
  }

  dynamic "backend_pool_load_balancing" {
    for_each = { for t in local.json_data.appservices : t.name => t }

    content {
      name                            = "backend-${backend_pool_load_balancing.value.id}-lb"
      sample_size                     = 4 # The number of samples to consider for load balancing decisions
      successful_samples_required     = 2 # The number of samples within the sample period that must succeed
      additional_latency_milliseconds = 0 # The additional latency in milliseconds for probes to fall into the lowest latency bucket
    }
  }

  dynamic "backend_pool_health_probe" {
    for_each = { for t in local.json_data.appservices : t.name => t }

    content {
      name         = "backend-${backend_pool_health_probe.value.id}-probe"
      enabled      = true
      path         = backend_pool_health_probe.value.probe
      protocol     = "Https"
    }
  }

  dynamic "backend_pool" {
    for_each = { for t in local.json_data.appservices : t.name => t }

    content {
      name = "backend-${backend_pool.value.id}"

      backend {
        host_header = "${backend_pool.value.name}.azurewebsites.net"
        address     = "${backend_pool.value.name}.azurewebsites.net"
        http_port   = 80
        https_port  = 443
      }

      load_balancing_name = "backend-${backend_pool.value.id}-lb"
      health_probe_name   = "backend-${backend_pool.value.id}-probe"
    }
  }
}