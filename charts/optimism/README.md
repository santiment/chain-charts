# Optimism

## Install

Add helm chart repository:

    helm repo add santiment https://santiment.github.io/chain-charts && helm repo update

Pull the chart locally:

    helm pull santiment/optimism

Install helm chart:

    helm install optimism ./optimism-0.0.1.tgz