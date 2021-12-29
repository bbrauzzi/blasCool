$graph:
- baseCommand: burned-area-severity
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
        APP_NAME: burned-area-severity
        APP_PACKAGE: app-burned-area-severity.dev.0.4.17
        APP_VERSION: 0.4.17
        PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/srv/conda/envs/env_scombi_do/bin
        _PROJECT: CPE
    ResourceRequirement: {}
  stderr: std.err
  stdout: std.out
- class: Workflow
  doc: This service takes a couple of calibrated optical images as inputs and estimates
    the severity of burnt areas, based on the Normalized Burn Ratio (NBR) index.
  id: burned-area-severity
  inputs:
    pre_event:
      doc: Optical calibrated pre-event acquisition with red, nir and swir22
      label: Optical calibrated pre-event acquisition with red, nir and swir22
      type: Directory
    post_event:
      doc: Optical calibrated post-event acquisition with red, nir and swir22
      label: Optical calibrated post-event acquisition with red, nir and swir22
      type: Directory
    aoi:
      doc: Area of interest expressed as Well-known text
      label: Area of interest expressed as Well-known text
      type: string?
  label: Burned Area Severity
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

