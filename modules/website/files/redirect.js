'use strict'

const domain_name = '${domain_name}'

exports.handler = (event, context, callback) => {

  const [record] = event.Records
  const {request} = record.cf
  const {headers, uri} = request
  const [host] = headers.host

  if (host.value === domain_name) {
    callback(null, request)
  } else {
    console.log(`Redirecting from $${host.value}$${uri} to $${domain_name}$${uri}`)
    callback(null, {
      status: '301',
      statusDescription: 'Moved Permanently',
      headers: {location: [{key: 'Location', value: `https://$${domain_name}$${uri}`}]}
    })
  }
}
