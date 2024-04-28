<h1>Infrastructure Setup on Google Cloud Platform using Hashicorp Terraform</h1>

<p>Enabling APIs<br>
In order to create resources on GCP, we will have to enable some basic APIs. This can be done via Terraform.</p>

<p>Below is a list of APIs that are required:<br>
<ol>
  <li>Compute Engine API: <code>compute.googleapis.com</code></li>
  <li>Serverless VPC Access API: <code>vpcaccess.googleapis.com</code></li>
  <li>Artifact Registry API: <code>artifactregistry.googleapis.com</code></li>
  <li>Certificate Manager API: <code>privateca.googleapis.com</code></li>
  <li>Cloud Build API: <code>cloudbuild.googleapis.com</code></li>
  <li>Cloud Deployment Manager V2 API: <code>deploymentmanager.googleapis.com</code></li>
  <li>Cloud DNS API: <code>dns.googleapis.com</code></li>
  <li>Cloud Functions API: <code>cloudfunctions.googleapis.com</code></li>
  <li>Cloud Key Management Service (KMS) API: <code>cloudkms.googleapis.com</code></li>
  <li>Cloud Logging API: <code>logging.googleapis.com</code></li>
  <li>Cloud Monitoring API: <code>monitoring.googleapis.com</code></li>
  <li>Cloud OS Login API: <code>oslogin.googleapis.com</code></li>
  <li>Cloud Pub/Sub API: <code>pubsub.googleapis.com</code></li>
  <li>Cloud Run Admin API: <code>run.googleapis.com</code></li>
  <li>Cloud SQL Admin API: <code>sqladmin.googleapis.com</code></li>
  <li>Cloud Storage: <code>storage.googleapis.com</code></li>
  <li>Container Registry API: <code>containerregistry.googleapis.com</code></li>
  <li>Eventarc API: <code>eventarc.googleapis.com</code></li>
  <li>Google Cloud Storage JSON API: <code>storage-api.googleapis.com</code></li>
  <li>Legacy Cloud Source Repositories API: <code>sourcerepo.googleapis.com</code></li>
  <li>Service Networking API: <code>servicenetworking.googleapis.com</code></li>
</ol>

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
