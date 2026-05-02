import { array, fn, hash } from "@ember/helper";
import { on } from "@ember/modifier";
import { LinkTo } from "@ember/routing";

import RouteTemplate from "ember-route-template";
import DButton from "discourse/components/d-button";
import HtmlWithLinks from "discourse/components/html-with-links";
import PluginOutlet from "discourse/components/plugin-outlet";
import UserAvatarFlair from "discourse/components/user-avatar-flair";
import UserBadge from "discourse/components/user-badge";
import UserStatusMessage from "discourse/components/user-status-message";
import boundAvatar from "discourse/helpers/bound-avatar";
import icon from "discourse/helpers/d-icon";
import emoji from "discourse/helpers/emoji";
import formatDate from "discourse/helpers/format-date";
import formatDuration from "discourse/helpers/format-duration";
import formatUsername from "discourse/helpers/format-username";
import htmlSafe from "discourse/helpers/html-safe";
import i18n from "discourse/helpers/i18n";
import replaceEmoji from "discourse/helpers/replace-emoji";
import themeSetting from "discourse/helpers/theme-setting";
import userStatus from "discourse/helpers/user-status";
import or from "truth-helpers/helpers/or";


export default RouteTemplate(
    <template>
        {{#if @controller.visible}}
            <PluginOutlet
            @name="before-user-card-content"
            @outletArgs={{hash user=@controller.user}}
            />
            {{#if @controller.loading}}
            <div class="d-user-card__header d-user-card__placeholder-animation">
            </div>
            <div class="d-user-card__main-content">
                <div class="d-user-card__main-content-top">
                <div class="d-user-card__id">
                    <span
                    class="card-avatar-placeholder d-user-card__placeholder-animation"
                    >
                    </span>
                    <span class="d-user-card__id-titles">
                    <div
                        class="d-user-card__titles-top d-user-card__placeholder-animation"
                    >
                    </div>
                    <div
                        class="d-user-card__titles-bottom d-user-card__placeholder-animation"
                    >
                    </div>
                    </span>
                </div>
                <div class="d-user-card__user-content">
                    <div
                    class="d-user-card__custom-fields .card-row .d-user-card__placeholder-animation"
                    >
                    </div>
                </div>
                </div>
                <div class="d-user-card__main-content-bottom">
                <div class="card-row d-user-card__placeholder-animation"></div>
                <div class="card-row d-user-card__placeholder-animation"></div>
                <div class="card-row d-user-card__placeholder-animation"></div>
                </div>
            </div>
            {{else}}
            <div class="d-user-card__container">
                <div class="uc-background use-bg"></div>
                <div class="d-user-card__header">
                {{! TODO: Add ability to edit image/color from usercard }}
                {{! <button class="d-user-card__edit-btn">
                <i class="fa-solid fa-pencil"></i>
                <span class="btn-label">Edit</span>
                </button> }}
                {{#unless @controller.contentHidden}}
                    {{#if (or @controller.showUserLocalTime @controller.user.location)}}
                    <div class="d-user-card__relative-time">
                        {{#if @controller.showUserLocalTime}}
                        <div class="d-user-card__time">
                            {{icon "far-clock"}}
                            <span
                            class="label"
                            >{{@controller.formattedUserLocalTime}}</span>
                        </div>
                        {{/if}}
                        {{#if @controller.user.location}}
                        <div class="d-user-card__location">
                            {{icon "location-dot"}}
                            {{#if @controller.themeSettingValid}}
                            <a
                                href={{@controller.userLocationLink}}
                                class="label d-user-card__location-link"
                            >{{@controller.user.location}}</a>
                            {{else}}
                            <span class="label">{{@controller.user.location}}</span>
                            {{/if}}
                        </div>
                        {{/if}}
                    </div>
                    {{/if}}
                {{/unless}}
                <div class="d-user-card__badges">
                    {{#if @controller.showBadges}}
                    {{#if @controller.user.featured_user_badges}}
                        {{#each @controller.user.featured_user_badges as |ub|}}
                        {{#if ub.badge}}
                            <UserBadge @badge={{ub.badge}} @user={{@controller.user}} @count={{ub.count}} />
                        {{/if}}
                        {{/each}}
                        {{#if @controller.showMoreBadges}}
                        <span class="d-user-card__badges-more">
                            <LinkTo @route="user.badges" @model={{@controller.user}}>
                            {{i18n (themePrefix "more_badges") count=@controller.moreBadgesCount}}
                            </LinkTo>
                        </span>
                        {{/if}}
                    {{/if}}
                    {{/if}}
                </div>
                </div>
                <div class="d-user-card__main-content">
                <div class="d-user-card__main-content-top">
                    <div class="d-user-card__id">
                    {{#if @controller.contentHidden}}
                        <span class="d-user-card__avatar">{{boundAvatar
                            @controller.user
                            "huge"
                        }}</span>
                    {{else}}
                        <a
                        href={{@controller.user.path}}
                        {{on
                            "click"
                            (fn @controller.handleShowUser @controller.user)
                        }}
                        class="d-user-card__avatar"
                        >{{boundAvatar @controller.user "huge"}}</a>
                    {{/if}}
                    <UserAvatarFlair @user={{@controller.user}} />
                    <div>
                        <PluginOutlet
                        @name="user-card-avatar-flair"
                        @connectorTagName="div"
                        @outletArgs={{hash user=@controller.user}}
                        />
                    </div>
                    <div class="d-user-card__id-titles">
                        <div class="d-user-card__titles-top">
                        <h1
                            class="d-user-card__name
                            {{@controller.staff}}
                            {{@controller.newUser}}
                            {{if @controller.nameFirst 'full-name' 'username'}}"
                            title="@{{@controller.user.username}}"
                        >
                            {{#if @controller.contentHidden}}
                            {{if
                                @controller.nameFirst
                                @controller.user.name
                                (formatUsername @controller.user.username)
                            }}
                            {{else}}
                            <a
                                href={{@controller.user.path}}
                                title={{if
                                @controller.nameFirst
                                @controller.user.name
                                (formatUsername @controller.user.username)
                                }}
                                {{on
                                "click"
                                (fn @controller.handleShowUser @controller.user)
                                }}
                                class="d-user-card__user-link"
                            >
                                {{if
                                @controller.nameFirst
                                @controller.user.name
                                (formatUsername @controller.user.username)
                                }}
                            </a>
                            {{/if}}
                            {{userStatus
                            @controller.user
                            currentUser=@controller.currentUser
                            }}
                        </h1>
                        {{#if @controller.user.staged}}
                            <span class="staged">{{i18n "user.staged"}}</span>
                        {{/if}}
                        <div>
                            <PluginOutlet
                            @name="user-card-post-names"
                            @connectorTagName="div"
                            @outletArgs={{hash user=@controller.user}}
                            />
                        </div>
                        </div>
                        <div class="d-user-card__titles-bottom">
                        {{#if @controller.nameFirst}}
                            <span class="d-user-card__user-name" title="Fullname">
                            @{{@controller.user.username}}
                            </span>
                        {{else}}
                            {{#if @controller.user.name}}
                            <span class="d-user-card__user-name" title="Fullname">
                                {{@controller.user.name}}
                            </span>
                            {{/if}}
                        {{/if}}
                        {{#if @controller.user.title}}
                            <span class="d-user-card__user-title">
                            {{if
                                @controller.user.name
                                " - "
                            }}{{@controller.user.title}}
                            </span>
                        {{/if}}
                        {{#if @controller.user.status}}
                            <UserStatusMessage @status={{@controller.user.status}} />
                        {{/if}}
                        </div>
                    </div>
                    </div>
                    <div class="d-user-card__user-content">
                    {{#if @controller.showFeaturedTopic}}
                        <div class="d-user-card__featured-topic">
                        <span class="d-user-card__featured-topic-title">{{emoji
                            "pushpin"
                            }}</span>
                        <LinkTo
                            @route="topic"
                            @models={{array
                            @controller.user.featured_topic.slug
                            @controller.user.featured_topic.id
                            }}
                            title={{i18n "user.featured_topic"}}
                            class="d-user-card__link"
                        >{{replaceEmoji
                            (htmlSafe @controller.user.featured_topic.fancy_title)
                            }}</LinkTo>
                        </div>
                    {{/if}}
                    {{#if @controller.user.profile_hidden}}
                        <span>{{i18n "user.profile_hidden"}}</span>
                    {{else if @controller.user.inactive}}
                        <span>{{i18n "user.inactive_user"}}</span>
                    {{/if}}
                        <div class="d-user-card__bio">
                        {{#if @controller.user.suspend_reason}}
                            <div class="d-user-card__suspension">
                            <div class="d-user-card__suspension-date">
                                {{icon "ban"}}
                                {{#if @controller.user.suspendedForever}}
                                {{i18n "user.suspended_permanently"}}
                                {{else}}
                                {{i18n
                                    "user.suspended_notice"
                                    date=@controller.user.suspendedTillDate
                                }}
                                {{/if}}
                            </div>
                            <div class="d-user-card__suspension-reason">
                                <span
                                class="d-user-card__suspension-reason-title"
                                >{{i18n "user.suspended_reason"}}</span>
                                <span
                                class="d-user-card__suspension-reason-description"
                                >{{@controller.user.suspend_reason}}</span>
                            </div>
                            </div>
                        {{else}}
                            {{#if @controller.user.bio_excerpt}}
                            <div class="d-user-card__bio-excerpt">
                                <HtmlWithLinks>
                                <p>{{replaceEmoji
                                    (htmlSafe @controller.user.bio_excerpt)
                                    }}</p>
                                </HtmlWithLinks>
                            </div>
                            {{/if}}
                        {{/if}}
                        </div>
                    {{#unless @controller.contentHidden}}
                        <div class="d-user-card__custom-fields">
                        <div class="d-user-card__custom-field-group">
                            {{#if @controller.user.time_read}}
                            <div class="d-user-card__field read">
                                <span class="d-user-card__custom-field-title">{{i18n
                                    "time_read"
                                }}</span>
                                <span
                                class="d-user-card__custom-field-data"
                                >{{formatDuration @controller.user.time_read}}
                                {{#if @controller.showRecentTimeRead}}
                                    ({{i18n
                                    "time_read_recently"
                                    time_read=@controller.recentTimeRead
                                    }})
                                {{/if}}
                                </span>
                            </div>
                            {{/if}}
                            {{#if @controller.user.last_posted_at}}
                            <div class="d-user-card__field posted">
                                <span class="d-user-card__custom-field-title">{{i18n
                                    "last_post"
                                }}</span>
                                <span
                                class="d-user-card__custom-field-data"
                                >{{formatDate
                                    @controller.user.last_posted_at
                                    leaveAgo="true"
                                }}</span>
                            </div>
                            {{/if}}
                            {{#if @controller.showCheckEmail}}
                            <div class="d-user-card__field email">
                                <span class="d-user-card__custom-field-data">
                                {{icon "envelope" title="user.email.title"}}
                                {{#if @controller.user.email}}
                                    {{@controller.user.email}}
                                {{else}}
                                    <DButton
                                    @action={{@controller.checkEmail}}
                                    @actionParam={{@controller.user}}
                                    @icon="envelope"
                                    @label="admin.users.check_email.text"
                                    class="btn-primary"
                                    />
                                {{/if}}
                                </span>
                            </div>
                            {{/if}}
                            <PluginOutlet
                            @name="user-card-metadata"
                            @connectorTagName="div"
                            @outletArgs={{hash user=@controller.user}}
                            />
                            {{#if @controller.publicUserFields}}
                            {{#each @controller.publicUserFields as |uf|}}
                                {{#if uf.value}}
                                <div
                                    class="d-user-card__field
                                    {{uf.field.dasherized_name}}"
                                >
                                    <span
                                    class="d-user-card__custom-field-title"
                                    >{{uf.field.name}}</span>
                                    <span class="d-user-card__custom-field-data">
                                    {{#each uf.value as |v|}}
                                        {{! some values are arrays }}
                                        {{v}}
                                    {{else}}
                                        {{uf.value}}
                                    {{/each}}
                                    </span>
                                </div>
                                {{/if}}
                            {{/each}}
                            {{/if}}
                        </div>
                        </div>
                    {{/unless}}
                    <PluginOutlet
                        @name="user-card-after-metadata"
                        @connectorTagName="div"
                        @outletArgs={{hash user=@controller.user}}
                    />
                    <div class="d-user-card__meta-data">
                        {{#if @controller.user.website_name}}
                        <div class="d-user-card__website">
                            {{icon "globe"}}
                            {{! template-lint-disable link-rel-noopener }}
                            <a
                            href={{@controller.user.website}}
                            rel="noopener {{unless
                                @controller.removeNoFollow
                                'nofollow ugc'
                            }}"
                            target="_blank"
                            class="d-user-card__link"
                            >{{@controller.user.website_name}}</a>
                            {{! template-lint-enable link-rel-noopener }}
                        </div>
                        {{/if}}
                        {{#if @controller.user.created_at}}
                        <div class="d-user-card__cakeday">
                            <img
                            height="20"
                            width="20"
                            src="https://emoji.discourse-cdn.com/twitter/cake.png?v=12"
                            alt
                            />
                            <span class="label">{{formatDate
                                (if
                                (settings.use_contract_date_for_cakeday)
                                @controller.user.custom_fields.employee_contract_start_date
                                @controller.user.created_at
                                )
                                leaveAgo="true"
                            }}</span>
                        </div>
                        {{/if}}
                        <span>
                        <PluginOutlet
                            @name="user-card-location-and-website"
                            @connectorTagName="div"
                            @outletArgs={{hash user=@controller.user}}
                        />
                        </span>
                    </div>
                    </div>
                </div>
                {{#if
                    (or
                    @controller.user.can_send_private_message_to_user
                    @controller.showFilter
                    @controller.hasUserFilters
                    @controller.showDelete
                    )
                }}
                    <div class="d-user-card__main-content-bottom">
                    <ul class="d-user-card__controls">
                        {{#if @controller.user.can_send_private_message_to_user}}
                        <li class="d-user-card__action">
                            <DButton
                            class="d-user-card__button btn-primary"
                            @action={{action
                                "composePM"
                                @controller.user
                                @controller.post
                            }}
                            @icon="envelope"
                            @label="user.private_message"
                            />
                        </li>
                        {{/if}}
                        <PluginOutlet
                        @name="user-card-below-message-button"
                        @connectorTagName="li"
                        @outletArgs={{hash
                            user=@controller.user
                            close=(action "close")
                        }}
                        />
                        {{#if @controller.showFilter}}
                        <li class="d-user-card__action">
                            <DButton
                            class="d-user-card__button btn-default"
                            @action={{action "filterPosts" @controller.user}}
                            @icon="filter"
                            @translatedLabel={{@controller.filterPostsLabel}}
                            />
                        </li>
                        {{/if}}
                        {{#if @controller.hasUserFilters}}
                        <li class="d-user-card__action">
                            <DButton
                            class="d-user-card__button btn-default"
                            @action={{@controller.cancelFilter}}
                            @icon="xmark"
                            @label="topic.filters.cancel"
                            />
                        </li>
                        {{/if}}
                        {{#if @controller.showDelete}}
                        <li class="d-user-card__action">
                            <DButton
                            class="d-user-card__button btn-danger"
                            @action={{@controller.deleteUser}}
                            @actionParam={{@controller.user}}
                            @icon="triangle-exclamation"
                            @label="admin.user.delete"
                            />
                        </li>
                        {{/if}}
                        <PluginOutlet
                        @name="user-card-additional-buttons"
                        @outletArgs={{hash
                            user=@controller.user
                            close=(action "close")
                        }}
                        />
                    </ul>
                    <PluginOutlet
                        @name="user-card-additional-controls"
                        @connectorTagName="div"
                        @outletArgs={{hash
                        user=@controller.user
                        close=(action "close")
                        }}
                    />
                    </div>
                {{/if}}
                </div>
            </div>
            {{/if}}

        {{/if}}
    </template>
);
