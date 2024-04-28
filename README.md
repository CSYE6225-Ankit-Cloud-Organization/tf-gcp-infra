<h1>Infrastructure Setup on Google Cloud Platform using Hashicorp Terraform</h1>

<p>Enabling APIs<br>
In order to create resources on GCP, we will have to enable some basic APIs. This can be done via Terraform.</p>

<p>Below is a list of APIs that are required:<br>
- Compute Engine API: compute.googleapis.com<br>
- Serverless VPC Access API: vpcaccess.googleapis.com<br>
- Artifact Registry API: artifactregistry.googleapis.com<br>
- Certificate Manager API: privateca.googleapis.com<br>
- Cloud Build API: cloudbuild.googleapis.com<br>
- Cloud Deployment Manager V2 API: deploymentmanager.googleapis.com<br>
- Cloud DNS API: dns.googleapis.com<br>
- Cloud Functions API: cloudfunctions.googleapis.com<br>
- Cloud Key Management Service (KMS) API: cloudkms.googleapis.com<br>
- Cloud Logging API: logging.googleapis.com<br>
- Cloud Monitoring API: monitoring.googleapis.com<br>
- Cloud OS Login API: oslogin.googleapis.com<br>
- Cloud Pub/Sub API: pubsub.googleapis.com<br>
- Cloud Run Admin API: run.googleapis.com<br>
- Cloud SQL Admin API: sqladmin.googleapis.com<br>
- Cloud Storage: storage.googleapis.com<br>
- Container Registry API: containerregistry.googleapis.com<br>
- Eventarc API: eventarc.googleapis.com<br>
- Google Cloud Storage JSON API: storage-api.googleapis.com<br>
- Legacy Cloud Source Repositories API: sourcerepo.googleapis.com<br>
- Service Networking API: servicenetworking.googleapis.com</p>

<p>Working with Terraform</p>

<ol>
  <li>Initialize Terraform<br>
    This installs the required providers and other plugins for our infrastructure.<br>
    <code>terraform init</code></li>
    
  <li>Create a <code>&lt;filename&gt;.tfvars</code></li>
  
  <li>Correct the formatting of your terraform code (optional)<br>
    <ol type="a">
      <li><code>terraform fmt</code></li>
    </ol>
  </li>

  <li>Validate the terraform configuration<br>
    <code>terraform validate</code></li>

  <li>Plan the cloud infrastructure<br>
    This command shows how many resources will be created, deleted or modified when we run terraform apply.<br>
    <code>terraform plan -var-file="&lt;filename&gt;.tfvars"</code></li>

  <li>Apply the changes/updates to the infrastructure to create it<br>
    <pre>
# execute the tf plan
# `--auto-approve` is to prevent tf from prompting you to say y/n to apply the plan
terraform apply --auto-approve -var-file="&lt;filename&gt;.tfvars"
    </pre>
  </li>

  <li>To destroy your infrastructure, use the command:<br>
    <code>terraform destroy --auto-approve -var-file="&lt;filename&gt;.tfvars"</code></li>
</ol>
