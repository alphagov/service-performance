module MetricsQuery
  class Query
    def initialize(time_period)
      @time_period = time_period
    end

    def all_by_dept
      q = 'SELECT D.natural_key as "object_id", D.name as "object_name", M.* FROM monthly_service_metrics M
      INNER JOIN services as S ON S.id = M.service_id
      INNER JOIN delivery_organisations as O ON O.id = S.delivery_organisation_id
      INNER JOIN departments as D ON D.id = O.department_id
      WHERE M.published = true AND month >= $1 AND month <= $2
      ORDER BY D.name, M.month;'

      rows = ActiveRecord::Base.connection.select_all(q, nil, encode_args(@time_period))
      flatten_by_object_id_date(rows)
    end

    def all_by_org
      q = 'SELECT O.natural_key as "object_id", O.name as "object_name", M.* FROM monthly_service_metrics M
      INNER JOIN services as S ON S.id = M.service_id
      INNER JOIN delivery_organisations as O ON O.id = S.delivery_organisation_id
      WHERE M.published = true AND month >= $1 AND month <= $2
      ORDER BY O.name, M.month;'

      rows = ActiveRecord::Base.connection.select_all(q, nil, encode_args(@time_period))
      flatten_by_object_id_date(rows)
    end

    def all_by_service
      q = 'SELECT S.natural_key as "object_id", S.name as "object_name", M.* FROM monthly_service_metrics M
      INNER JOIN services as S ON S.id = M.service_id
      WHERE M.published = true AND month >= $1 AND month <= $2
      ORDER BY S.name, M.month;'

      rows = ActiveRecord::Base.connection.select_all(q, nil, encode_args(@time_period))
      flatten_by_object_id_date(rows)
    end

    def department_by_org(dept)
      q = 'SELECT O.natural_key as "object_id", O.name as "object_name", M.* FROM monthly_service_metrics M
        INNER JOIN services as S ON S.id = M.service_id
        INNER JOIN delivery_organisations as O ON O.id = S.delivery_organisation_id
        INNER JOIN departments as D ON D.id = O.department_id
        WHERE M.published = true AND month >= $1 AND month <= $2 AND D.natural_key =$3
        ORDER BY O.name, M.month;'

      rows = ActiveRecord::Base.connection.select_all(q, nil, encode_args(@time_period, other: dept))
      flatten_by_object_id_date(rows)
    end

    def department_by_service(dept)
      q = 'SELECT S.natural_key as "object_id", S.name as "object_name", M.* FROM monthly_service_metrics M
        INNER JOIN services as S ON S.id = M.service_id
        INNER JOIN delivery_organisations as O ON O.id = S.delivery_organisation_id
        INNER JOIN departments as D ON D.id = O.department_id
        WHERE M.published = true AND month >= $1 AND month <= $2 AND D.natural_key =$3
        ORDER BY S.name, M.month;'

      rows = ActiveRecord::Base.connection.select_all(q, nil, encode_args(@time_period, other: dept))
      flatten_by_object_id_date(rows)
    end

    def org_by_service(org)
      q = 'SELECT S.natural_key as "object_id", S.name as "object_name", M.* FROM monthly_service_metrics M
        INNER JOIN services as S ON S.id = M.service_id
        INNER JOIN delivery_organisations as O ON O.id = S.delivery_organisation_id
        INNER JOIN departments as D ON D.id = O.department_id
        WHERE M.published = true AND month >= $1 AND month <= $2 AND O.natural_key =$3
        ORDER BY S.name, M.month;'

      rows = ActiveRecord::Base.connection.select_all(q, nil, encode_args(@time_period, other: org))
      flatten_by_object_id_date(rows)
    end

    def service_metrics(service)
      q = 'SELECT S.natural_key as "object_id", S.name as "object_name", M.* FROM monthly_service_metrics M
        INNER JOIN services as S ON S.id = M.service_id
        WHERE M.published = true AND month >= $1 AND month <= $2 AND S.natural_key =$3
        ORDER BY S.name, M.month;'

      rows = ActiveRecord::Base.connection.select_all(q, nil, encode_args(@time_period, other: service))
      flatten_by_date(rows)
    end

  private

    def flatten_by_object_id_date(rows)
      data = Hash.new { |hash, key|
        hash[key] = Hash.new { |newhash, newkey|
          newhash[newkey] = []
        }
      }

      rows.each_with_object(data) { |row, acc|
        k = [row["object_id"], row["object_name"]]
        remove_unneeded_items(row)
        acc[k][row["month"]] << row
        acc
      }
    end

    def flatten_by_date(rows)
      data = Hash.new { |hash, key|
        hash[key] = []
      }

      rows.each_with_object(data) { |row, acc|
        remove_unneeded_items(row)
        acc[row["month"]] << row
        acc
      }
    end

    def remove_unneeded_items(row)
      row.delete("object_id")
      row.delete("object_name")
      row.delete("id")
      row.delete("created_at")
      row.delete("updated_at")
    end

    def encode_args(time_period, other: nil)
      args = [
        [nil, time_period.starts_on.to_s],
        [nil, time_period.ends_on.to_s]
      ]
      args << [nil, other] if other
      args
    end
  end
end
