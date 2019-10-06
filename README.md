# Firmadetaljer

This is an iOS application written in Swift where you can search for information about Norwegian companies. The search is done against the Brønnøysundsregistrene API: https://confluence.brreg.no/display/DBNPUB/API

I have also made an Android version: [Android Firmadetaljer](https://github.com/fredrik9000/Firmadetaljer_Android)

#### The app has the following features:

- Search for companies by name
- Search for companies by organization number
- View company details
- Navigate to parent company details (for those that have parent companies)
- Navigate to the company homepage
- Viewed companies are persisted and shown in its own list when not searching
- Option for clearing search history (meaning the persisted companies will be deleted)
- Dark mode
- The app supports English and Norwegian languages

#### Potential improvements:

- Show location for a given firm on a map.
- Add a way to filter search by zip code or company size.
- The maximum number of companies returned by the API is 100. Add pagination behaviour so that more data is retrieved as the user scrolls.

## Screenshots

![Simulator Screen Shot - iPad Pro (12 9-inch) (3rd generation) - 2019-09-19 at 22 25 41](https://user-images.githubusercontent.com/13121494/65363836-406c4100-dc0e-11e9-9765-d3418efa269d.png)

![Simulator Screen Shot - iPad Pro (12 9-inch) (3rd generation) - 2019-09-19 at 22 26 55](https://user-images.githubusercontent.com/13121494/65363841-42360480-dc0e-11e9-8c5d-5dce3e22fb34.png)

![saved_companies_light_iphone](https://user-images.githubusercontent.com/13121494/65363685-78bf4f80-dc0d-11e9-9629-191a5786c815.png)

![company_details_light_iphone](https://user-images.githubusercontent.com/13121494/65363686-7b21a980-dc0d-11e9-8e55-a0ee464baea3.png)
