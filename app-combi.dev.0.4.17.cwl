$graph:
- baseCommand: combi
  class: CommandLineTool
  hints:
    DockerRequirement:
      dockerPull: docker.terradue.com/scombi-do:dev0.4.17
  id: clt
  inputs:
    red_channel:
      inputBinding:
        position: 1
        prefix: --red-channel
      type: Directory
    green_channel:
      inputBinding:
        position: 2
        prefix: --green-channel
      type: Directory
    blue_channel:
      inputBinding:
        position: 3
        prefix: --blue-channel
      type: Directory
    color_ops:
      inputBinding:
        position: 4
        prefix: --color-ops
      type: string?
    aoi:
      inputBinding:
        position: 5
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
        APP_NAME: combi
        APP_PACKAGE: app-combi.dev.0.4.17
        APP_VERSION: 0.4.17
        PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/srv/conda/envs/env_scombi_do/bin
        _PROJECT: CPE
    ResourceRequirement: {}
  stderr: std.err
  stdout: std.out
- class: Workflow
  doc: This service provides an RGB full resolution combination of bands from single
    or multiple EO data products (optical or radar). The output has the finest resolution
    as of the input data.
  id: combi
  inputs:
    red_channel:
      doc: Single band asset to be used in the RGB combination for the RED channel
      label: Single band asset to be used in the RGB combination for the RED channel
      type: Directory
    green_channel:
      doc: Single band asset to be used in the RGB combination for the GREEN channel
      label: Single band asset to be used in the RGB combination for the GREEN channel
      type: Directory
    blue_channel:
      doc: Single band asset to be used in the RGB combination for the BLUE channel
      label: Single band asset to be used in the RGB combination for the BLUE channel
      type: Directory
    color_ops:
      doc: Color operations
      label: Color operations
      type: string?
    aoi:
      doc: Area of interest expressed in WKT
      label: Area of interest expressed in WKT
      type: string?
  label: Multi-Sensor Band Composite
  outputs:
  - id: wf_outputs
    outputSource:
    - step_1/results
    type: Directory
  steps:
    step_1:
      in:
        red_channel: red_channel
        green_channel: green_channel
        blue_channel: blue_channel
        color_ops: color_ops
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

