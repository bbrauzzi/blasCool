$graph:
- baseCommand: iris-coregistration
  class: CommandLineTool
  hints:
    DockerRequirement:
      dockerPull: docker.terradue.com/iris-coregistration:dev0.1.2
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
    coreg_type:
      inputBinding:
        position: 4
        prefix: --coregistration
      type:
        - symbols: &id001
          - Automatic
          - Rigid
          - Elastic
          type: enum
  outputs:
    results:
      outputBinding:
        glob: .
      type: Directory
  requirements:
    EnvVarRequirement:
      envDef:
        APP_DOCKER_IMAGE: docker.terradue.com/iris-coregistration:dev0.1.2
        APP_NAME: iris-coregistration
        APP_PACKAGE: app-iris-coregistration.dev.0.1.2
        APP_VERSION: 0.1.2
        PATH: /srv/conda/envs/env_iris_coregistration/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/srv/conda/envs/env_iris_coregistration/bin
        _PROJECT: CPE
    ResourceRequirement: {}
  stderr: std.err
  stdout: std.out
- class: Workflow
  doc: This service performs a multi-sensor co-registration of two optical calibrated
    single band assets employing a full field displacement measurement based on the
    Dense Inverse Search (DIS) method for Optical Flow. Output of the service are
    single band rasters from reference and the co-registered secondary assets
  id: iris-coregistration
  inputs:
    pre_event:
      doc: Optical calibrated pre-event single band asset path
      label: Optical calibrated pre-event single band asset path
      type: Directory
    post_event:
      doc: Optical calibrated post-event single band asset path
      label: Optical calibrated post-event single band asset path
      type: Directory
    aoi:
      doc: Area of interest in Well-known Text (WKT)
      label: Area of interest in Well-known Text (WKT)
      type: string?
    coreg_type:
      default: Elastic
      doc: Coregistration type
      label: Coregistration type
      type:
        - symbols: &id001
          - Automatic
          - Rigid
          - Elastic
          type: enum
  label: IRIS Optical Image Co-registration
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
        coreg_type: coreg_type
      out:
      - results
      run: '#clt'
$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
s:softwareVersion: 0.1.2
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf