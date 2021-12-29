$graph:
- baseCommand: sar-amplitude-change
  class: CommandLineTool
  hints:
    DockerRequirement:
      dockerPull: docker.terradue.com/scombi-do:dev0.4.17
  id: clt
  inputs:
    pre_event:
      inputBinding:
        position: 1
        prefix: --pre-event
      type: Directory
    post_event:
      inputBinding:
        position: 2
        prefix: --post-event
      type: Directory
    aoi:
      inputBinding:
        position: 3
        prefix: --aoi
      type: string?
  outputs:
    results:
      outputBinding:
        glob: .
      type: Directory
  requirements:
    EnvVarRequirement:
      envDef:
        APP_DOCKER_IMAGE: docker.terradue.com/scombi-do:dev0.4.17
        APP_LOGGING: https://faas.terradue.com/function/metrics-collect-on-demand-services-uat
        APP_NAME: sar-amplitude-change
        APP_PACKAGE: app-sar-amplitude-change.dev.0.4.17
        APP_VERSION: 0.4.17
        PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/srv/conda/envs/env_scombi_do/bin
        _PROJECT: CPE
    ResourceRequirement: {}
  stderr: std.err
  stdout: std.out
- class: Workflow
  doc: This service provides an RGB composite based on backscatter values in dB using
    suitable GRD pair. Output product represent the Sigma0 in dB of the pre-event
    product, the Sigma0 in dB post-event product and the RGB combination.
  id: sar-amplitude-change
  inputs:
    pre_event:
      doc: SAR calibrated pre-event acquisition
      label: SAR calibrated pre-event acquisition
      type: Directory
    post_event:
      doc: SAR calibrated post-event acquisition
      label: SAR calibrated post-event acquisition
      type: Directory
    aoi:
      doc: Area of interest expressed in WKT
      label: Area of interest expressed in WKT
      type: string?
  label: SAR Amplitude Change
  outputs:
  - id: wf_outputs
    outputSource:
    - step_1/results
    type: Directory
  steps:
    step_1:
      in:
        pre_event: pre_event
        post_event: post_event
        aoi: aoi
      out:
      - results
      run: '#clt'
$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
s:softwareVersion: 0.4.17
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

