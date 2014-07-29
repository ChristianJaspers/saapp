class Api::V1::ResourcesController < Api::RestrictedApplicationController
  def index
    render_json(stub_json, 200)
  end

  private

  def stub_json
    {
      reports: stub_reports,
      users: stub_users,
      categories: stub_categories,
      arguments: stub_arguments
    }
  end

  def stub_reports
    [
      {
        id: 1,
        position: 1,
        level: 81,
        name: "My activity",
        updated_at: "2014-03-28T16:00:00+01:00"
      },
      {
        id: 2,
        position: 2,
        level: 24,
        name: "My team activity",
        updated_at: "2014-03-28T16:00:00+01:00"
      },
      {
        id: 3,
        position: 3,
        level: 91,
        name: "All teams activity",
        updated_at: "2014-03-28T16:00:00+01:00"
      }
    ]
  end

  def stub_users
    [
      {
        avatar_thumb_url: "http://lorempixel.com/200/200/?t=123562",
        display_name: "Ireneusz Skrobis",
        experience: 0,
        email: "ireneusz.skrobisz@selleo.com",
        avatar_url: "http://lorempixel.com/400/400/?t=123231",
        id: 1
      },
      {
        avatar_thumb_url: "http://lorempixel.com/200/200/?t=12332",
        display_name: "Tomasz Czana",
        experience: 14,
        email: "tomasz.czana@selleo.com",
        avatar_url: "http://lorempixel.com/400/400/?t=12352",
        id: 2
      },
      {
        avatar_thumb_url: "http://lorempixel.com/200/200/?t=123",
        display_name: "Dawid Poslinki (Unicorn)",
        experience: 128,
        email: "dawid.poslinski@selleo.com",
        avatar_url: "http://lorempixel.com/400/400/?t=1234",
        id: 3
      },
      {
        avatar_thumb_url: "http://lorempixel.com/200/200/?t=12",
        display_name: "Sebastian Ewak",
        experience: 1283,
        email: "sebastian.ewak@selleo.com",
        avatar_url: "http://lorempixel.com/400/400/?t=124",
        id: 4
      },
      {
        avatar_thumb_url: "http://lorempixel.com/200/200/?t=12312",
        display_name: "Bartlomiej Wojtowicz",
        experience: 1251,
        email: "bartlomiej.wojtowicz@selleo.com",
        avatar_url: "http://lorempixel.com/400/400/?t=12332",
        id: 5
      }
    ]
  end

  def stub_categories
    [
      {
        position: 1,
        id: 1,
        name: "Android tablets"
      },
      {
        position: 2,
        id: 2,
        name: "Oculus Rift"
      },
      {
        position: 3,
        id: 3,
        name: "4k tv"
      },
      {
        position: 4,
        id: 4,
        name: "Car audio"
      }
    ]
  end

  def stub_arguments
    [
      {
        rating: 99,
        created_at: "2014-03-28T16:00:00+01:00",
        feature: "5 inch screen",
        updated_at: "2014-03-28T16:00:00+01:00",
        benefit: "Simpler use",
        category_id: 1,
        id: 1
      },
      {
        rating: 87,
        created_at: "2014-03-28T16:00:00+01:00",
        feature: "#2 Lorem ipsum dolor sit amet feature",
        updated_at: "2014-03-28T16:00:00+01:00",
        benefit: "#2 Lorem ipsum dolor sit amet benefit",
        category_id: 1,
        id: 2
      },
      {
        rating: 38,
        created_at: "2014-03-28T16:00:00+01:00",
        feature: "#3 Lorem ipsum dolor sit amet feature",
        updated_at: "2014-03-28T16:00:00+01:00",
        benefit: "#3 Lorem ipsum dolor sit amet benefit",
        category_id: 2,
        id: 3
      }
    ]
  end
end
