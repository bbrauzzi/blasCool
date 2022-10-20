$graph:
- baseCommand: coregistered-stack
  class: CommandLineTool
  hints:
    DockerRequirement:
      dockerPull: docker.terradue.com/scombi-do:dev0.7.3
  id: clt
  inputs:
    input_reference:
      type:
        inputBinding:
          position: 1
          prefix: --input_reference
        items: Directory
        type: array
    bands:
      inputBinding:
        position: 2
        prefix: --bands
      type: string
    aoi:
      inputBinding:
        position: 3
        prefix: --aoi
      type: string?
    reference_asset:
      inputBinding:
        position: 4
        prefix: --reference_asset
      type: string
    s_expressions:
      type:
      - 'null'
      - inputBinding:
          position: 5
          prefix: --s-expressions
        items: string
        type: array
  outputs:
    results:
      outputBinding:
        glob: .
      type: Directory
  requirements:
    EnvVarRequirement:
      envDef:
        APP_DOCKER_IMAGE: docker.terradue.com/scombi-do:dev0.7.3
        APP_LOGGING: https://faas-ope.terradue.com/function/metrics-collect-on-demand-services-uat
        APP_NAME: coregistered-stack
        APP_PACKAGE: app-coregistered-stack.dev.0.7.3
        APP_VERSION: 0.7.3
        PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/srv/conda/envs/env_scombi_do/bin
        _PROJECT: CPE
    ResourceRequirement: {}
  stderr: std.err
  stdout: std.out
- class: Workflow
  doc: This service provides a multi-mission and multi-temporal image stack of co-registered
    assets from different optical and SAR sensors. It performs heterogeneous co-registration
    in the image domain of secondary assets to the reference. It can also generate
    assets from the co-registered stack using band arithmetic.
  id: coregistered-stack
  inputs:
    input_reference:
      doc: Input product reference
      label: Input product reference
      type: Directory[]
    bands:
      doc: List of comma separated bands in the form <int>.<band_name> (e.g. 1.red,1.green,2.blue,...)
      label: List of comma separated bands in the form <int>.<band_name> (e.g. 1.red,1.green,2.blue,...)
      type: string
    aoi:
      doc: Area of interest expressed as Well-known text
      label: Area of interest expressed as Well-known text
      type: string?
    reference_asset:
      doc: Reference asset in the list (e.g. 3.blue)
      label: Reference asset in the list (e.g. 3.blue)
      type: string
    s_expressions:
      doc: s expression defined as cbn:expression
      label: s expression defined as cbn:expression
      type: string[]?
  label: Co-registered Co-located stacking
  outputs:
  - id: wf_outputs
    outputSource:
    - step_1/results
    type: Directory
  steps:
    step_1:
      in:
        input_reference: input_reference
        bands: bands
        aoi: aoi
        reference_asset: reference_asset
        s_expressions: s_expressions
      out:
      - results
      run: '#clt'
$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
s:softwareVersion: 0.7.3
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

