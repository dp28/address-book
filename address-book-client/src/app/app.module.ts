import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';
import { AppRoutingModule } from './app-routing.module';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import 'rxjs/Rx';

import { AppComponent } from './app.component';
import { PeopleComponent } from './people/people.component';
import { PeopleApiService } from './people-api.service';
import { OrganisationApiService } from './organisation-api.service';
import { ApiService } from './api.service';
import { PersonComponent } from './person/person.component';
import { OrganisationComponent } from './organisation/organisation.component';
import { OrganisationsComponent } from './organisations/organisations.component';

@NgModule({
  declarations: [
    AppComponent,
    PeopleComponent,
    PersonComponent,
    OrganisationComponent,
    OrganisationsComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule,
    AppRoutingModule,
    NgbModule.forRoot()
  ],
  providers: [ApiService, PeopleApiService, OrganisationApiService],
  bootstrap: [AppComponent]
})
export class AppModule { }
