#!/bin/bash

set -ouex pipefail

rpm-ostree kargs \
--append=slab_nomerge \
--append=init_on_alloc=1 \
--append=init_on_free=1 \
--append=page_alloc.shuffle=1 \
--append=pti=on \
--append=randomize_kstack_offset=on \
--append=vsyscall=none \
--append=selinux=1 \
--append=security=selinux \
--append=intel_iommu=on \
--append=efi=disable_early_pci_dma