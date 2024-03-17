<h1>Infrastructure Setup on Google Cloud Platform using Hashicorp Terraform</h1>

<p>Enabling APIs<br>
In order to create resources on GCP, we will have to enable some basic APIs. This can be done via Terraform.</p>

<p>Below is a list of APIs that are required:<br>
compute.googleapis.com<br>
dns.googleapis.com<br>
logging.googleapis.com<br>
monitoring.googleapis.com<br>
servicenetworking.googleapis.com</p>

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
