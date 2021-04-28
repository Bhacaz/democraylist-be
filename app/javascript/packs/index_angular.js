// Run this Angular example by adding the following HTML markup to your view:
//
// <hello-angular>Loading...</hello-angular>
//
// <%= javascript_pack_tag 'index_angular' %>

import { enableProdMode } from '@angular/core'

if (process.env.NODE_ENV === 'production') {
    enableProdMode()
}

require('../index_angular')
