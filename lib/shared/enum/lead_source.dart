enum LeadSource { advertisement }

extension LeadSourceGetters on LeadSource {
  bool get isAdvertisement => this == LeadSource.advertisement;
}
