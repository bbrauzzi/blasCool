$graph:
- baseCommand: multi-sensor-composite
  class: CommandLineTool
  hints:
    DockerRequirement:
      dockerPull: docker.terradue.com/scombi-do:dev0.4.17
  id: clt
  inputs:
    input_reference:
      type:
        inputBinding:
          position: 1
          prefix: --input_reference
        items: Directory
        type: array
    aoi:
      inputBinding:
        position: 2
        prefix: --aoi
      type: string?
    red_expression:
      inputBinding:
        position: 3
        prefix: --red-expression
      type: string
    green_expression:
      inputBinding:
        position: 4
        prefix: --green-expression
      type: string
    blue_expression:
      inputBinding:
        position: 5
        prefix: --blue-expression
      type: string
    alpha_expression:
      inputBinding:
        position: 6
        prefix: --alpha-expression
      type: string?
    color_ops:
      inputBinding:
        position: 7
        prefix: --color-ops
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
        APP_NAME: multi-sensor-composite
        APP_PACKAGE: app-multi-sensor-composite.dev.0.4.17
        APP_VERSION: 0.4.17
        PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/srv/conda/envs/env_scombi_do/bin
        _PROJECT: CPE
    ResourceRequirement: {}
  stderr: std.err
  stdout: std.out
- class: Workflow
  doc: This service provides an RGB full resolution combination of bands from single
    or multiple EO data product (optical or radar). The output has the finest resolution
    as of the input data (only if all selected bands are coming from the same sensor).
  id: multi-sensor-composite
  inputs:
    input_reference:
      doc: Input product reference
      label: Input product reference
      type: Directory[]
    aoi:
      doc: Area of interest expressed as Well-known text
      label: Area of interest expressed as Well-known text
      type: string?
    red_expression:
      doc: Red channel expression
      label: Red channel expression
      type: string
    green_expression:
      doc: Green channel expression
      label: Green channel expression
      type: string
    blue_expression:
      doc: Blue channel expression
      label: Blue channel expression
      type: string
    alpha_expression:
      doc: Alpha channel expression (optional)
      label: Alpha channel expression (optional)
      type: string?
    color_ops:
      doc: Color operations
      label: Color operations
      type: string?
  label: Advanced Multi-Sensor Band Composite
  outputs:
  - id: wf_outputs
    outputSource:
    - step_1/results
    type: Directory
  steps:
    step_1:
      in:
        input_reference: input_reference
        aoi: aoi
        red_expression: red_expression
        green_expression: green_expression
        blue_expression: blue_expression
        alpha_expression: alpha_expression
        color_ops: color_ops
      out:
      - results
      run: '#clt'
$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
s:softwareVersion: 0.4.17
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

