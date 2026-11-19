mock_provider "nomatron" {
  mock_resource "nomatron_service_account" {
    defaults = {
      id = "11111111-1111-1111-1111-111111111111"
    }
  }
}

run "basic_service_account" {
  command = apply

  variables {
    name        = "basic-ci"
    description = "Basic automation identity"
  }

  assert {
    condition     = output.name == "basic-ci"
    error_message = "The module should return the service account name."
  }

  assert {
    condition     = length(output.assignment_ids) == 0
    error_message = "The basic case should not create role assignments."
  }

}

run "complete_service_account" {
  command = apply

  variables {
    name      = "complete-ci"
    is_active = true
    assignments = [
      {
        role   = "release-manager"
        domain = "global"
      },
      {
        role            = "release-manager"
        organization_id = "11111111-1111-1111-1111-111111111111"
      }
    ]
  }

  assert {
    condition = toset(keys(output.assignment_ids)) == toset([
      "release-manager:global",
      "release-manager:org:11111111-1111-1111-1111-111111111111"
    ])
    error_message = "Role assignments should use the role and normalized domain as their keys."
  }

  assert {
    condition     = output.is_active == true
    error_message = "The module should pass through the configured active status."
  }

  assert {
    condition     = length(output.assignment_ids) == 2
    error_message = "The module should return an ID for each role assignment."
  }
}

run "assignment_rejects_both_domain_inputs" {
  command = plan

  variables {
    name = "invalid-both-domains"
    assignments = [{
      role            = "release-manager"
      domain          = "global"
      organization_id = "11111111-1111-1111-1111-111111111111"
    }]
  }

  expect_failures = [var.assignments]
}

run "assignment_rejects_old_organization_domain" {
  command = plan

  variables {
    name = "invalid-old-domain"
    assignments = [{
      role   = "release-manager"
      domain = "organization:11111111-1111-1111-1111-111111111111"
    }]
  }

  expect_failures = [var.assignments]
}

run "assignment_rejects_bare_uuid_domain" {
  command = plan

  variables {
    name = "invalid-bare-domain"
    assignments = [{
      role   = "release-manager"
      domain = "11111111-1111-1111-1111-111111111111"
    }]
  }

  expect_failures = [var.assignments]
}

run "assignment_rejects_empty_role" {
  command = plan

  variables {
    name = "invalid-empty-role"
    assignments = [{
      role   = " "
      domain = "global"
    }]
  }

  expect_failures = [var.assignments]
}
