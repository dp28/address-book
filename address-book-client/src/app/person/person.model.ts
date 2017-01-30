export interface Person {
  name: string;
  id?: number;
  contact_details: {
    email?: string;
    phone_number?: string;
    street_address?;
    additional_street_address?: string;
    city?: string;
    county?: string;
    country?: string;
    postcode?: string;
  }
}
